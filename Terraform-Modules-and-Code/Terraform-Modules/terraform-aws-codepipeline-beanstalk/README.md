# tf-aws-codepipeline-beanstalk

**The following resources are defined in the root module main.tf:**

codepipeline_bucket:S3 bucket to store source and build artifacts.\
block_codepipeline_bucket:Set permissions on the s3 bucket.

codepipeline_role:Data reference to beanstalk codepipeline role created using tf-coreservices.

codepipeline:AWS CodePipeline for deploying applications on elastic beanstalk.The pipeline consists of the following stages.

- Source:Stage for connecting codepipeline to github for source code and to store the code in s3 bucket codepipeline_bucket as SourceArtifact.
- Build:Stage for creating build.Refers to the AWS CodeBuild project created by tf-coreservices.
- Deploy:Stage to deploy beanstalk application by invoking a lambda function created by tf-coreservices.
- ManageRelease:Stage to approve or reject deployment.Consists of two actions executed in serial.The first action ApproveRelease uses AWS CodePipeline provider Manual.The second action SwapEnvURL invokes a lambda function upon approval to swap the beanstalk environment cname.Refers to a Lambda function created by tf-coreservices.
- ManageRollback:Stage to rollback.

codepipeline_webhook:CodePipeline Webhook.\
repository_webhook:Wire the CodePipeline webhook into a GitHub repository

# AWS Codepipeline with beanstalk Terraform module

Terraform module to create the Codepipeline with beanstalk on AWS.

These types of resources are supported:

* [Elastic Beanstalk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_application)
* [CodePipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline)

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
  region = "ap-southeast-2"
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
module "codepipeline-beanstalk_module" {
  source       = "github.com/sgs-dxc/tf-aws-codepipeline-beanstalk.git?ref=v1.0"
  region       = local.region
  default_tags = local.default_tags
  env_prefix   = local.env_prefix
  app          = "TestingSample"
  env_1        = "testingSample-Env1"
  env_2        = "testingSample-Env2"
  OAuthToken   = "b858b011befbd931b12351301fcf5fc07c02c689"
  Owner        = "DX"
  Repo         = "poc_bluegreendeploy1"
  Branch       = "master"
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

## CodePipeline Beanstalk Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS region | `string` | n/a | yes |
| default_tags | default tags | `map(string}` | n/a | yes |
| env_prefix | beanstalk prefix for cname | `string` | n/a | yes |
| app | beanstalk application cname | `string` | n/a | yes |
| env_1 | beanstalk environment name | `string` | n/a | yes |
| env_2 | beanstalk environment name | `string` | n/a | yes |
| OAuthToken | github token to connect codepipeline to github | `string` | n/a | yes |
| Owner | github user | `string` | n/a | yes |
| Repo | github repo name | `string` | n/a | yes |
| Branch | github branch for source code | `string` | n/a | yes |

## CodePipeline Beanstalk Outputs

| Name | Description |
|------|-------------|
| codepipeline_name | Beanstalk codepipeline name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).

