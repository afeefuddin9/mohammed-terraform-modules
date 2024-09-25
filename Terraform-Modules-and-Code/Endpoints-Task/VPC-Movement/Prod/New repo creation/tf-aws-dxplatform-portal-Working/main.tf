# Provider Version Configuration
terraform {
  #backend "s3" {
   # bucket = "tfstate-dx-platform-portal"
    #key    = "stage/terraform.tfstate"
    #region = "ap-southeast-1"
  #}
cloud {
    organization = "dxc-dxpf"
    workspaces {
      #name = "tf-aws-dxplatform-portal-stage" #Commenting old stage workspace name
      name = "tf-aws-dxplatform-portal-prod" #Commenting old prod workspace name
    }
  }
  required_version = ">= 0.13.2"
  required_providers {
    aws = ">= 3.5.0"
  }
}
provider "aws" {
  region = local.region
  ignore_tags {
    keys = ["Usage", "Usage-tag-source", "Usage-tag-update-time"]
  }
}
locals {
  default_tags = {
    Project          = "dxplatformportal-prod" #updating -stage to -prod
    Managed          = "Terraform"
    Owner            = "dxplatform"
    Billing          = "dxplatform" # This tag should be set as project specific to better cost allocation
    automated-backup = "yes"
    "Patch Group"    = "amazonlinux2"
    Managed          = "Terraform"
  }
  # Define the application name ex: VxProd, DigibotQa
  Application_name = "dxplatformportal"
  Environment = "Prod"
  # Define the application stage ex: QA, testing, production
  environment_stage = "prod" #updating -stage to -prod
  envPrefix         = "${local.Application_name}-${local.environment_stage}"
  environment_name  = local.environment_stage
  region            = "ap-southeast-1"
}

#ASG Module Locals
#Infra_tags = {
#automated-backup = "yes"
#"Patch Group"    = "amazonlinux2"
#Managed          = "Terraform"
#}

#### ALB 

module "ALB" {
  # Refer the github release version for details features details.
  #source = "github.com/sgs-dxc/terraform-aws-alb.git?ref=v1.5" #commenting remote module 
  source = "./modules/alb" #adding local module 
  region = local.region
  Environment = local.Environment
  # Unique name for Application Load Balancer
  envPrefix = local.envPrefix
  # VPC ID for ALB
  vpc_id = "vpc-8481afe3"
  # Public Subnet ID's for ALB
  alb_subnet1 = "subnet-5c31233b"
  alb_subnet2 = "subnet-20bdbe69"
  #  alb_subnet3 = subnet-3ca76e65
  # Security Groups for ALB
  alb_security_grp  = ["sg-0b8596d57d5da1109", "sg-066cff47579adc6ec", "sg-0f6fe1f0cf3e67d6c", "sg-0ad279f7c608e0792", "sg-0d0b7e4029a649675"]
  target_group_port = "80"

  # enable_api1_target_group                 = true
  #create_api_listener_path_rule1_with_auth = true
  #create_api_listener_path_rule2_with_auth = true
  #enable_second_target_group               = true
  #enable_api2_target_group                 = true
  create_listener_rule_without_auth = false
  create_listener_with_auth         = true
  create_listener_without_auth      = false
  #path_values                       = ["/"]
  #api1_name                         = local.Application_name
  #ec2_instance_port                 = "80"
  #create_listener_path_rule_with_auth  = true
  #create_listener_path_rule2_with_auth = true
  # SSL Certificate ARN for ALB
  certificate_arn        = "arn:aws:acm:ap-southeast-1:768502287836:certificate/4a8f0357-b09d-4204-9084-f7282f39678d"
  authorization_endpoint = "https://dx-infra.auth.ap-southeast-1.amazoncognito.com/oauth2/authorize"
  # client_id              = "4aoncumcjbcm7ne7toj0akdvtm" #***Commenting old Client_id
  # client_secret          = "1l1vhkc7m88h0e4spf1rifeorh5hgbebopsp23agfnm8kbd3vnns" #***Commenting old secret 
  client_id              = "212qndff2rl5hpqlobqjus4dds" #***Adding new Client_id
  client_secret          = "6ov2ak7uc3289e9dvlntkfok4outrklofdm6vbl57l11v24jrfr" #***Adding new secret 
  issuer                 = "https://cognito-idp.ap-southeast-1.amazonaws.com/ap-southeast-1_HxhkZHuGI"
  token_endpoint         = "https://dx-infra.auth.ap-southeast-1.amazoncognito.com/oauth2/token"
  user_info_endpoint     = "https://dx-infra.auth.ap-southeast-1.amazoncognito.com/oauth2/userInfo"

  s3_bucket        = "dxpf-alb-logs-singapore"
  s3_bucket_prefix = "dxplatformportal-prod" #updating -stage to -prod
  # Default Tags
  default_tags  = local.default_tags
  #sns_topic_arn = "arn:aws:sns:ap-southeast-1:768502287836:DXPlatformPortal-Static-Staging-EmailSNSTopic-3VXZYU6YDCD8" #Commenting old staging ARN
  sns_topic_arn = "arn:aws:sns:ap-southeast-1:768502287836:DXPlatformPortal-Static-Prod-EmailSNSTopic-1RX6DETNGILDU" #Adding Prod ARN

}

####

resource "aws_ssm_parameter" "cw_agent_dxplatformportal-prod" { #updating -stage to -prod
  description = "Cloudwatch agent config to configure custom log"
  name        = "/dxplatformportal/prod/dxplatformportal-prod/cloudwatch-agent/cw_agent_config" #updating -stage to -prod
  type        = "String"
  value       = file("./user_data/dxplatform-portal-prod/cw_agent_config.json")
  tags        = local.default_tags
}


module "autoscale_app" {
  #source         = "github.com/sgs-dxc/terraform-aws-ASG.git?ref=v1.2.5"#commenting remote module 
  source = "./modules/asg" #adding local module 
  BillingTag     = "dxplatform"
  NameTag        = "dxplatformportal-prod" #updating -stage to -prod
  Volume_NameTag = "dxplatformportal-prod" #updating -stage to -prod
  OwnerTag       = "dxplatform"
  # replace the values accordingly
  ec2_subnet_a                = "subnet-20bdbe69"
  ec2_subnet_b                = "subnet-5c31233b"
  env_prefix                  = local.envPrefix
  #image_id                    = "ami-07a423a1374be86f0" #commenting staging ami 
  image_id                    = "ami-0d07675d294f17973"  #Adding prod ami from aws for launch template 
  instance_type               = "t2.micro"
  key_pair_name               = "DXInfra"
  asg_instance_profile_prefix = "dxplatformportal-prod" #updating -stage to -prod
  desired_capacity            = "1"
  max_instance_size           = "1"
  min_instance_size           = "1"
  monitor                     = true
  public_ip_address           = false
  EBS_volume_size             = "30"
  region                      = local.region
  # replace the values accordingly
  sec_grp = ["sg-0b8596d57d5da1109", "sg-0d2aebd6362d7d24f"]

  # Please find the userdata in S3 bucket named "dxpf-infra-ops" and key "EC2-ASG-user-data"
  #userDataDetails = base64encode(templatefile("./user_data/dxplatform-portal-stage/userdata_to_ec2.sh", { ssm_cloudwatch_config = aws_ssm_parameter.cw_agent_dxplatformportal-stage.name })) #Commenting old user data
  userDataDetails = base64encode(templatefile("./user_data/dxplatform-portal-prod/userdata_to_ec2.sh", { ssm_cloudwatch_config = aws_ssm_parameter.cw_agent_dxplatformportal-prod.name })) #Adding new user data



  vpc_id = "vpc-8481afe3"
  # Existing Target Group ARN (replace the values accordingly)
  target_grp_arn          = [module.ALB.target_group_arns1]
  enable_asg_notification = true
  # replace the values accordingly
  #sns_topic_arn = "arn:aws:sns:ap-southeast-1:768502287836:DXPlatformPortal-Static-Staging-EmailSNSTopic-3VXZYU6YDCD8" #Commenting old staging ARN
  sns_topic_arn = "arn:aws:sns:ap-southeast-1:768502287836:DXPlatformPortal-Static-Prod-EmailSNSTopic-1RX6DETNGILDU" #Adding Prod ARN
}

