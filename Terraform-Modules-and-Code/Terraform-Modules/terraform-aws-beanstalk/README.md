# tf-aws-beanstalk

**The following resources are defined in the root module main.tf:**

bg-app:AWS Elastic Beanstalk application to deploy web applications.

bg-env1:AWS Beanstalk environment(blue) with tag IsProduction set to True.

bg-env2:AWS Beanstalk environment(green) with tag IsProduction set to False.

These types of resources are supported:

* [Elastic Beanstalk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_application)

## Terraform version
Terraform ~> 0.13.2

## Provider version
AWS Provider ~> 3.5.0

## Configuration Usage

```hcl
# Provider Version Configuration
terraform {
  required_version = ">= 0.13.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.5.0"
    }
  }
}
provider "aws" {
 region = local.region
  ignore_tags {
    keys =  ["Usage"]
  }
}
locals {
  default_tags = {
    Project = "Dx"
    Managed = "Terraform"
    Owner   = "Dx"
    Billing = "Dx" # This tag should be set as project specific to better cost allocation
  }
  region     = "ap-southeast-2"
  env_prefix = "TestingSample"
}
data "aws_caller_identity" "current" {}
module "beanstalk_module" {
  source       = "github.com/sgs-dxc/tf-beanstalk-env.git?ref=v1.0"
  region       = local.region
  default_tags = local.default_tags
  env_prefix   = local.env_prefix
  vpc_id = "vpc-0973a63239900e54d"
  instance_subnets = ["subnet-032d1f3fcd746b22f", "subnet-08361f952c791059a"]
  appdescription = "Bluegreen app deployed through TF"
  stack_name = "64bit Amazon Linux 2018.03 v2.9.6 running Python 3.6"
  envdescription = "Bluegreen Env deployed through TF"
  cert_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:server-certificate/selfsign-dxinfra-elastic-beanstalk-x509"
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
| terraform | ~> 0.13.2 |
| aws | ~> 3.5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.5.0 |

## Elastic Beanstalk Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS region | `string` | n/a | yes |
| default_tags | default tags | `map(string}` | n/a | yes |
| env_prefix | beanstalk prefix for cname | `string` | n/a | yes |
| vpc_id | Define the VPC id | `string` | n/a | yes |
| instance_subnets | vpc subnet for beanstalk ec2 instances  | `list(string)` | n/a | yes |
| appdescription | beanstalk application description | `string` | n/a | yes |
| stack_name | beanstalk platform name | `string` | n/a | yes |
| envdescription | environment description | `string` | n/a | yes |
| prod_tags | tag to identify prod env | `map(string)` | "IsProduction" : "True" | yes |
| stg_tags | tag to identify stg env | `map(string)` | "IsProduction" : "False" | yes |
| ssl_port | listener in application load balancer | `map(string)` | "IsProduction" : "False" | yes |
| cert_arn | arn of the ssl certificate | `map(string)` | "IsProduction" : "False" | yes |

## Elastic Beanstalk Outputs

| Name | Description |
|------|-------------|
| beanstalk_application_name | Beanstalk codepipeline name |
| beanstalk_environment_1 | Beanstalk env1 name |
| beanstalk_environment_2 | Beanstalk env2 name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).

