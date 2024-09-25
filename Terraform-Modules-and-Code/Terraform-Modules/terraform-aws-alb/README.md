# AWS Application Load Balancer (ALB) Terraform module

Terraform module which creates Application Load Balacner and Target Group resources on AWS.

These types of resources are supported:

* [Application Load Balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)
* [Target Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group)

## Terraform version
Terraform ~> 0.13.2

## Provider version
AWS Provider ~> 3.5.0

## Configuration Usage

```hcl
# Provider Version Configuration
provider "aws" {
  region = local.region
  ignore_tags {
    keys = ["Usage", "Usage-tag-source", "Usage-tag-update-time"]
  }
}
terraform {
  required_version = "~> 1.3.0"
   required_providers {
    aws = "~> 4.0"
    }
}
# Set the local variables
locals {
  region = "us-west-2"
  Application_Name = "DxPlatform"
  Environment      = "Test"

  # Define the application stage ex: QA, testing, production
  envPrefix           = "${local.Application_Name}-${local.Environment}"
  alarm_sns_topic_arn = "arn:aws:sns:us-west-2:768502287836:Lakshmi_test:67d9ef4e-2029-485b-b0b9-785e0192335c"
  default_tags = {
    Project     = "dxplatform"
    Managed     = "Terraform"
    Billing     = "dxplatform" # This tag should be set as project specific to better cost allocation
    Owner       = "dxplatform"
    Environment = "${local.Environment}"
    target_group_port          = "80"
  # acm_domain_name = "admin_server"
  certificate_arn = "arn:aws:iam::768502287836:server-certificate/self-digibot-ecs"
  }
}

# We you want to use the ACM domain name as cert, please replace the certificate_arn variable with "data.aws_acm_certificate.cert.name". 
/*data "aws_acm_certificate" "cert" {
  domain = local.acm_domain_name
}*/
data "aws_caller_identity" "current" {}
# Create Application Load Balancer and Target Group.
module "ALB" {
  # Refer the github release version for details features details. 
  source = "github.com/sgs-dxc/tf-aws-alb?ref=v1.4"
  region = local.region
  # Unique name for Application Load Balancer
  envPrefix = local.envPrefix

  # Deployment environment;
  # If this value set to true, you may provide the S3 bucket details for Access Logs.  
  # production_evn = local.production_evn
  # Existing S3 Bucket for ALB Access Log
  # s3_bucket        = local.s3_bucket
  # s3_bucket_prefix = local.s3_bucket_prefix

  # VPC ID for ALB
  vpc_id = module.VPC.vpc_id
  # Public Subnet ID's for ALB
  alb_subnet1 = module.VPC.lb_subnet_a_id
  alb_subnet2 = module.VPC.lb_subnet_b_id
  # Security Groups for ALB
  alb_security_grp  = [module.custom_sg.security_group_lb1]
  target_group_port = local.target_group_port
 
  # enable_stickiness = false  (By default the value is false, set the variable to "true" to enable sticky session)

  # Below variables are to create listener with cognito and without cognito. Enable the variables accordingly. the defined values are the default values.
  # create_listener_with_auth = local.create_listener_with_auth
  # create_listener_without_auth = local.create_listener_without_auth

  # To enable second target group and lister, enable these variables
  #enable_second_target_group = true
  #create_listener_rule_without_auth_for_TG2 = true
  #create_listener_with_auth_for_TG2 = true

  # SSL Certificate ARN for ALB
  certificate_arn = local.certificate_arn
  authorization_endpoint     = local.authorization_endpoint
  client_id                  = local.client_id
  client_secret              = local.client_secret
  issuer                     = local.issuer
  token_endpoint             = local.token_endpoint
  user_info_endpoint         = local.user_info_endpoint

  # Default Tags
  default_tags  = local.default_tags
  sns_topic_arn = module.sns-email-topic.arn
}
```

## Usage

To run this module you need to execute:

```bash
$ terraform init
$ terraform plan -out "plan.out"
$ terraform apply "plan.out"
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.3.0 |
| aws | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 4.0 |

## Application Load Balancer Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS Region where resources should be created  | `string` | `""` | Yes |
| env\_prefix | Creates a unique name for Application Load Balancer beginning with the specified prefix | `string` | `""` | Yes |
| environment\_name |Deployment environment name, eg: Dev, QA or Production  | `string` | n/a | Yes |
| vpc\_id | VPC ID in which ALB will be created | `string` | `""` | Yes |
| alb\_subnet1, alb\_subnet2 | Public Subnet ID's for ALB  | `string` | `""` | Yes |
| alb\_security\_grp, alb\_security\_grp\_01, alb\_security\_grp\_02 | Security Groups for ALB  | `string` | `""` | Yes |
| alb\_certificate\_arn | SSL Certificate ARN for ALB   | `string` | `""` | Yes |
| s3\_bucket | S3 Bucket Name for ALB Access Logs Configuration | `string` | `""` | no |
| default\_tags | Default Tags | `list(map(string))` | `[]` | Yes |

## Application Load Balancer Outputs
| Name | Description |
|------|-------------|
| alb\_id |The ID of the Application load balancer created. |
| alb\_arn |The ARN of the Application load balancer created. |
| alb\_dns\_name |The DNS name of the load balancer. |
| target\_group\_arns |ARNs of the target groups. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
