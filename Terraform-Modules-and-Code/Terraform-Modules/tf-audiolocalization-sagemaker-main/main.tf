#
# MAINTAINER DX platform
#
terraform {
  required_version = "1.3.7"
}

provider "aws" {
  region                  = "us-east-1"
  ignore_tags {
    keys = ["Usage", "Usage-tag-source", "Usage-tag-update-time"]
}
}

# Get the usera and account information
data "aws_caller_identity" "current" {
}



locals {

  Application_Name = "audiolocalization"
  # Define the application stage ex: Prod,Pr-Prod, QA, Dev,Stable and Test
  Environment = "Dev"
  region      = "us-east-1"
  default_tags = {
    Project     = "generative-ai"
    Managed     = "Terraform"
    Billing     = "generative-ai" # This tag should be set as project specific to better cost allocation
    Owner       = "audiolocalization"
    Environment = local.Environment
  }
  



  envPrefix = "${local.Application_Name}-${local.Environment}"
  ## Sagemaker domain 
  name               = "domain-audio-localization"
  environment = "dev"
  enable_sagemaker_domain                  = true
  sagemaker_domain_name                    = "domain-audio-localization"
  sagemaker_domain_auth_mode               = "IAM"
  sagemaker_domain_app_network_access_type = "VpcOnly"

# Code Repository

repository_url = " "
  

  # Sagemaker model
  enable_sagemaker_model             = false
  sagemaker_model_name               = "audiolocalization"

# Sagemaker notebook instance
  # enable_sagemaker_notebook_instance        = true
  # sagemaker_notebook_instance_name          = "audiolocalization"
  # sagemaker_notebook_instance_instance_type = "ml.m5.4xlarge"
  # default_tags = {
  #   Project     = "audiolocalization"
  #   Managed     = "Terraform"
  #   Billing     = "audiolocalization" # This tag should be set as project specific to better cost allocation
  #   Owner       = "audiolocalization"
  #   Environment = local.Environment
  # }
 }

## Create VPC resource
module "vpc" {
  #source             = "github.com/sgs-dxc/tf-vpc.git?ref=v1.8.0"
  source            = "app.terraform.io/dxc-dxpf/vpc/aws"
  version           = "1.8.0"
  envPrefix          = local.envPrefix
  environment_type   = local.Environment
  azs                = "us-east-1a,us-east-1b"
  region             = local.region
  cidr               = "10.19.0.0/23"
  lb_subnet_a_cidr   = "10.19.0.64/27"
  lb_subnet_b_cidr   = "10.19.0.128/27"
  db_subnet_a_cidr   = "10.19.0.192/26"
  db_subnet_b_cidr   = "10.19.0.0/26"
  web_subnet_a_cidr  = "10.19.1.64/26"
  web_subnet_b_cidr  = "10.19.1.128/26"
  default_tags       = local.default_tags
  enable_nat_gateway = true
}

resource "aws_security_group" "security_group_sagemaker" {
  description = "Security group for audiolocalization sagemaker resources"
  vpc_id      = module.vpc.vpc_id
  name        = "audiolocalization-sagemaker-sg"
  ingress {
    description = "Allow traffic for audiolocalization sagemaker resources"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["10.19.0.0/23"]
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name" = "audiolocalization-sagemaker-sg"
    },
    local.default_tags,
  )
}


## Create ECR repository

resource "aws_ecr_repository" "audiolocalization-dev" {
  name                 = "audiolocalization-dev"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.default_tags
}

## Create first S3 bucket for application data

resource "aws_s3_bucket" "audiolocalization-s3-dev" {
  

  bucket_prefix = "audiolocalization-sagemaker-dev"
  tags          = local.default_tags
}


resource "aws_s3_bucket_server_side_encryption_configuration" "audiolocalization-s3-dev" {
  

  bucket = aws_s3_bucket.audiolocalization-s3-dev.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}



resource "aws_s3_bucket_public_access_block" "mwaa1-dev" {
  

  bucket = aws_s3_bucket.audiolocalization-s3-dev.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}


## Create second s3 bucket 

resource "aws_s3_bucket" "audiolocalization-s3-prod" {
  

  bucket_prefix = "audiolocalization-sagemaker-prod"
  tags          = local.default_tags
}


resource "aws_s3_bucket_server_side_encryption_configuration" "audiolocalization-prod" {
  

  bucket = aws_s3_bucket.audiolocalization-s3-prod.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}



resource "aws_s3_bucket_public_access_block" "mwaa1-prod" {
  

  bucket = aws_s3_bucket.audiolocalization-s3-prod.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}



###############################################################################
###SageMaker Execution Role
###############################################################################
data "template_file" "sm_execution_policy" {
  template = file("modules/iam/sm_execution_policy.json")

  vars = {}
}

data "template_file" "assume_role_policy" {
  template = file("modules/iam/assume_role_policy.json")

  vars = {}
}

resource "aws_iam_policy" "sm_execution_policy" {
  name        = "tf_sm_execution_policy-audiolocalization-sagemaker"
  description = "IAM Policy to allow SageMaker the necessary permissions to access AWS Services and Resources."
  policy      = data.template_file.sm_execution_policy.rendered
}

resource "aws_iam_role" "sm_execution_role" {
  name                = "tf_sagemaker_execution_role-audiolocalization-sagemaker"
  assume_role_policy  = data.template_file.assume_role_policy.rendered
  managed_policy_arns = [aws_iam_policy.sm_execution_policy.arn, "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess", "arn:aws:iam::aws:policy/AmazonSageMakerCanvasFullAccess","arn:aws:iam::768502287836:policy/IAMPassRole", "arn:aws:iam::aws:policy/AWSServiceCatalogAdminFullAccess", "arn:aws:iam::aws:policy/AWSServiceCatalogAdminFullAccess","arn:aws:iam::aws:policy/AWSServiceCatalogEndUserFullAccess","arn:aws:iam::aws:policy/AmazonSageMakerCanvasFullAccess","arn:aws:iam::aws:policy/AmazonSageMakerCanvasAIServicesAccess"]
}





resource "aws_sagemaker_user_profile" "karthik_sagemaker_user_profile" {
  user_profile_name = "karthik-sagemaker-profile"
  domain_id         = module.sagemaker.sagemaker_domain_id
  user_settings {
    execution_role  = aws_iam_role.sm_execution_role.arn
    security_groups = [aws_security_group.security_group_sagemaker.id]
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }
}

resource "aws_sagemaker_user_profile" "mandira_sagemaker_user_profile" {
  user_profile_name = "mandira-sagemaker-profile"
  domain_id         = module.sagemaker.sagemaker_domain_id
  user_settings {
    execution_role  = aws_iam_role.sm_execution_role.arn
    security_groups = [aws_security_group.security_group_sagemaker.id]
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }
}

resource "aws_sagemaker_user_profile" "sukul_sagemaker_user_profile" {
  user_profile_name = "sukul-sagemaker-profile"
  domain_id         = module.sagemaker.sagemaker_domain_id
  user_settings {
    execution_role  = aws_iam_role.sm_execution_role.arn
    security_groups = [aws_security_group.security_group_sagemaker.id]
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }
}

###########################################################################################
module "sagemaker" {
  source      = "./modules/sagemaker"
  name        = local.name
  environment = local.environment


  ## Sagemaker domain 

  enable_sagemaker_domain                  =  local.enable_sagemaker_domain
  sagemaker_domain_name                    =  local.sagemaker_domain_name
  sagemaker_domain_auth_mode               =  local.sagemaker_domain_auth_mode
  sagemaker_domain_vpc_id                  =  module.vpc.vpc_id
  tags                                     =  local.default_tags
  sagemaker_domain_subnet_ids              = [module.vpc.db_subnet_a_id, module.vpc.db_subnet_b_id]
  sagemaker_domain_app_network_access_type = local.sagemaker_domain_app_network_access_type
  sagemaker_domain_default_user_settings = {
    "execution_role"  = aws_iam_role.sm_execution_role.arn
    "security_groups" = [aws_security_group.security_group_sagemaker.id]
  }
}

module "lambda" {
  source             = "./modules/lambda"
  lambdaFunctionName = "audio-localization-preprocessing"
  subnet_id          = ["subnet-00e6f8f85e3fb8a77"] 
  sg_id              = ["sg-0cc1f67e2717a3d2c"]
  default_tags       = local.default_tags
  maximum_event_age_in_seconds = "21600"
  layer_name = local.envPrefix
  role_arn = "arn:aws:iam::768502287836:role/service-role/test-audio-localization-role-s43tln6k"
}

resource "aws_s3_bucket_notification" "audio-localization" {
  bucket = "audio-localization"

   lambda_function {
    lambda_function_arn = "arn:aws:lambda:us-east-1:768502287836:function:audio-localization-preprocessing"
    events              = ["s3:ObjectCreated:Put", "s3:ObjectCreated:Post", "s3:ObjectCreated:CompleteMultipartUpload"]
    filter_prefix       = "input/"
  }
}

resource "aws_lambda_permission" "allow_s3_invocation_audio-localization" {
  statement_id  = "AllowS3Invocation"
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-1:768502287836:function:audio-localization-preprocessing"
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::audio-localization"
}



###########################################################################################
###Dynamody instance
module "dynamodb_table" {
  #source      = "github.com/sgs-dxc/tf-aws-dynamodb.git?ref=v1.0"
  Environment = "Dev"
  region      = local.region
  source  = "app.terraform.io/dxc-dxpf/dynamodb/aws"
  version = "1.1.0"
  envPrefix   = local.envPrefix
  hash_key    = "id"

  attributes = [
    {
      name = "id"
      type = "N"
    }
  ]

tags = local.default_tags
point_in_time_recovery_enabled = "true"
}