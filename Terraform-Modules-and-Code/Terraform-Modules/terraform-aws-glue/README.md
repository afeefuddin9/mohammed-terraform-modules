# tf-aws-glue
tf-aws-glue
# AWS glue Terraform module

Terraform configuration to provision AWS glue along with attached Internet Gateway, route table, egress rule to access the internet and a set of subnets. 

These types of resources are supported:

## Terraform version
Terraform ~> 0.13.2

## Provider version
AWS Provider ~> 3.5.0

```hcl
provider "aws" {
  region = local.region
    ignore_tags {
    keys = ["Usage", "Usage-tag-source", "Usage-tag-update-time"]
  }
}

locals {
  Application_Name = "testproject"
  # Define the application stage ex: Prod,Pr-Prod, QA, Dev,Stable and Test
  environment = "dev"
  region      = "us-west-2"
  envPrefix   = "${local.Application_Name}-${local.environment}"
  #alarm_sns_topic_arn = module.sns-email-topic-Maas-blockchain.arn
  default_tags = {
    Env     = "dev"
    Owner   = "test-project"
    Project = "test-project"
    Billing = "test-project"
    Owner   = "test-project"
    Managed = "terraform"
  }
  default_arguments = {
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = "true"
    "--enable-job-insights"              = "false"
    "--enable-observability-metrics"     = "false"
    "--job-language"                     = "python"
}
}
data "aws_caller_identity" "current" {}

module "glue" {
  source                  = "github.com/sgs-dxc/tf-aws-glue.git?ref=v1.0"
  aws_account_id     = data.aws_caller_identity.current.account_id
  aws_region         = local.region
  availability_zone  = "us-west-2a"
  python_version     = "3.9"
  default_tags       = local.default_tags
  s3_bucket          = "dxpf-infra-ops"
  s3_object_key      = "s3://dxpf-infra-ops/test/"
  vpc_id             = "vpc-04a1219e70896df72"
  subnet_id          = "subnet-069e360e594bf0344"
  envPrefix          = local.environment
  s3_log_bucket_name = "dxpf-infra-ops"
  default_arguments  = local.default_arguments
}
```
## Usage

To run this module you need to execute:

```bash
$ terraform init
$ terraform plan -out "plan.out"
$ terraform apply "plan.out"
```
## Authors

Module managed by [Sony DXC Platform](https://).
