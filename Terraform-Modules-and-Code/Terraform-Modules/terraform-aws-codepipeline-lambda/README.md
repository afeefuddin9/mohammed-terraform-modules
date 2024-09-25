# tf-aws-codepipeline-lambda

**The following resources are defined in the root module main.tf:**

codepipeline_bucket:S3 bucket to store source and build artifacts.\
block_codepipeline_bucket:Set permissions on the s3 bucket.

codepipeline_role:Data reference to lambda codepipeline role created using tf-coreservices.\
lambda_role:Data reference to a role for creating a CloudFormation stack created using tf-coreservices.

codepipeline:AWS CodePipeline for deploying lambda functions.The pipeline consists of the following stages.

 - Stage for connecting codepipeline to github for source code and to store the code in s3 bucket codepipeline_bucket as SourceArtifact.
 - Build:Stage for creating build.Refers to the AWS CodeBuild project created by tf-coreservices.
 - Deploy:Stage to deploy a new version of lambda function.This stage consists of two actions which are executed in serial.The first action Deploy creates a CloudFormation template and the following action Execute-Changeset creates a CloudFormation stack.
 - ManageRelease:Stage to approve or reject deployment.Consists of two actions executed in serial.The first action ApproveRelease uses AWS CodePipeline provider Manual.The second action UpdateAlias invokes a lambda function upon approval to update the aliases by swapping their versions.Refers to a Lambda function created by tf-coreservices.
 - ManageRollback:Stage to rollback.
 
codepipeline_webhook:CodePipeline Webhook.\
repository_webhook:Wire the CodePipeline webhook into a GitHub repository

These type of resources are supported:
* [CodePipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline)
* [Lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)

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
    aws = ">= 3.5.0"
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
# Create the codepipeline for ECS continuous Deployment .  
module "codepipeline" {
  source = "github.com/sgs-dxc/tf-aws-codepipeline-lambda.git?ref=v1.0"
  region      = local.region
  default_tags = local.default_tags
  env_prefix  = local.env_prefix
  Owner           = "sgs-dxc"
  OAuthToken      = "03db3700c2a80dc06f45259830bd45"
  Repo            = "sample-ecs"
  Branch          = "release"
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

## AWS Codepipeline Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS Region where resources should be created | `string` | `""` | Yes |
| env\_prefix | Creates a unique name for autoscaling group beginning with the specified prefix | `string` | `""` | Yes |
| Owner | Github username for connecting codepipeline to github | `string` | `""` | Yes |
| OAuthToken | Github user token for connecting codepipeline to github  | `string` | `""` | Yes |
| Repo | Github repository name | `string` | `""` | Yes |
| Branch | Repository branch name. | `string` | `""` | Yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
