provider "aws" {
  region = "ap-southeast-1"
  ignore_tags {
    keys = ["Usage","Usage-tag-source","Usage-tag-update-time"]
  }
}
locals {
  Application_Name = "DxPlatform"
  region           = "ap-southeast-1"
  env_prefix        = "DXPlatformPortal-Static-Staging"
  environment_name = "staging"
  Environment = "Stable"
  default_tags = {
    Project = "dxplatform"
    Managed = "Terraform"
    Owner   = "dxplatform"
    Billing = "dxplatform" # This tag should be set as project specific to better cost allocation
    application = "dxplatform-portal"
    
  }
}

/*
# Configure S3 as backend for terraform state file management.
terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "768502287836-terraform-state-prod-ap-southeast-2"
    key    = "DXPlatformPortal-Static-Staging/terraform.tfstate"
    region = "ap-southeast-2"

    # Replace this with your DynamoDB table name!
   dynamodb_table = "terraform-prod-up-and-running-locks"
   encrypt        = true
  }
}
*/
data "aws_caller_identity" "current" {}
output "account_id" {
  value = "data.aws_caller_identity.current.account_id"
}
module "sns-email-topic" {
  #source          = "github.com/sgs-dxc/tf-sns-email?ref=v1.1"
  source  = "app.terraform.io/dxc-dxpf/sns-email/aws"
  version = "1.1.0"
  display_name    = "${local.env_prefix}-codepipeline-topic"
  email_addresses = ["DXC-Infra-Operation@sony.com"]
  stack_name      = local.env_prefix
}
module "iam_roles" {
  source = "./modules/iam"
}

module "s3" {
  #source          = "github.com/sgs-dxc/tf-aws-s3?ref=v1.1"
  source  = "app.terraform.io/dxc-dxpf/s3/aws"
  version = "1.1.0"
  bucket-name     = lower("${local.env_prefix}-bucket-${local.region}")
  enable_versions = true
  restrict_public = true
  default_tags    = var.default_tags
}

#Adding New Bucket Tags
# module "s3" {
#   source = "./modules/s3"
#   envPrefix = local.env_prefix
#   Environment = local.Environment
#   region = local.region
#   bucket-name     = lower("${local.env_prefix}-bucket-${local.region}")
#   enable_versions = "true"
#   enable_lifecycle = "false"
#   replication_role = "false"
#   create_replication_bucket = "false"
#   restrict_public = true
#   default_tags    = var.default_tags

# }


# resource "aws_s3_bucket_server_side_encryption_configuration" "dxplatform-portal-staging" {
#   bucket = aws_s3_bucket.dxplatform-portal-staging.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }


module "codepipeline" {
  #source                 = "github.com/sgs-dxc/tf-aws-ec2-codepipeline?ref=v1.0"
  source                 = "./modules/codepipeline"
  env_prefix             = var.env_prefix
  region                 = var.region
  s3_bucket              = module.s3.s3-bucket
  codedeploy_role        = module.iam_roles.codedeploy_arn
  codepipeline_role      = module.iam_roles.codepipeline_arn
  deployment_type        = var.deployment_type
  deployment_option      = var.deployment_option
  deployment_config_name = var.deployment_config_name
  autoscaling_groups     = var.autoscaling_groups
  target_group           = var.target_group
  alarms                 = var.alarms
  sns_topic_arn          = module.sns-email-topic.arn
  Owner                  = var.Owner
  Branch                 = var.Branch
  Repo                   = var.Repo
  #OAuthToken             = var.OAuthToken
  trigger_events     = var.trigger_events
  default_tags           = var.default_tags
}
