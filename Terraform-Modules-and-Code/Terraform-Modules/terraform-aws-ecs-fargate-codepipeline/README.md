# Terraform module of AWS codepipeline for ECS(Fargate).

Terraform configuration to provision AWS CodePipeline for deploying containers on AWS ECS. It consists of a root module with a configuration file ,output file and a variable file. The configuration file defines all the resources to be created, the variable file defines the various input variables along with their default values and the output file lists the output variables. 

AWS CodePipeline for deploying containers on ecs. The pipeline consists of the following stages.
   - Source: The Source stage has 2 actions which are executed in parallel. Action Source used for connecting codepipeline to github for source code and to store the code in s3 bucket codepipeline_bucket as SourceArtifact. Action GetDeployScripts is used for fetching deployment script from s3 bucket ecsbg_scriptbucket and store it as DeployScripts in s3 bucket codepipeline_bucket. 
   - Build: Stage for creating a new image and push it to ecr.Refers to the AWS CodeBuild project created by tf-coreservices.
   - Deploy: Stage to update task definition and ecs cluster service using codebuild project.Refers to the AWS CodeBuild project created by tf-coreservices.
   
> This pipeline requires imagedefinitions.json file as an input to Deploy action. Refer to the sample builspec.yml file in the GitHub repo for generating the file imagedefinitions.json during build.

These type of resources are supported:

* [CODEPIPELINE](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline)

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
/*# Configure S3 as backend for terraform state file management.
terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "768502287836-terraform-state-prod-ap-southeast-2"
    # Replace <applicationnameEnv> with your application key!
    key    = "applicationnameEnv/terraform.tfstate"
    region = "ap-southeast-2"
    # Replace this with your DynamoDB table name!
   dynamodb_table = "terraform-prod-up-and-running-locks"
   encrypt        = true
  }
}*/
data "aws_caller_identity" "current" {}
# Create the codepipeline for ECS continuous Deployment . 
module "pipeline" {
  source = "./codepipeline"
  cluster_name        = "Dx-dev-test-App"
  container_name      = "Dx-dev-test"
  env_prefix = "TestingCodepipeline"
  repository_url      = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-southeast-2.amazonaws.com/lakshmi-test-ecs"
  BService    = "Dx-dev-test-ServiceA"
  GService    = "Dx-dev-test-ServiceB"
  git_repository = {
  github_oauth_token = "your-token-here"
  owner = "sgs-dxc"
  name = "Test_fargate_source_code"
  branch = "main"
  }
  default_tags = local.default_tags
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
| cluster_name | Name of the ECS Cluster   | `string` | `""` | Yes |
| BService | ECS Service Name for Production  | `string` | `""` | Yes |
| TaskName | ECS Task definition json name  | `string` | `""` | Yes |
| container_name | ECS Task definition name  | `string` | `""` | Yes |
| env\_prefix | Creates a unique name for autoscaling group beginning with the specified prefix | `string` | `""` | Yes |
| repository\_url | ECR image repo uri | `string` | `""` | Yes |
| git_repository | Repository details | `list(map(string))` | `[]` | yes |
| default\_tags | Default Tags | `list(map(string))` | `[]` | yes |

## AWS Codepipeline Outputs
| Name | Description |
|------|-------------|
| pipeline_id | ECS Codepipeline ID |
| pipeline_s3_id | Codepipeline s3 ID |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
