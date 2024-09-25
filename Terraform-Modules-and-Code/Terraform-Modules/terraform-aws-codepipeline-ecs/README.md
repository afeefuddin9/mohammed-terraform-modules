# Terraform module of AWS codepipeline for ECS.
Terraform configuration to provision AWS CodePipeline for deploying containers on AWS ECS. It consists of a root module with a configuration file ,output file and a variable file. The configuration file defines all the resources to be created, the variable file defines the various input variables along with their default values and the output file lists the output variables. 

AWS CodePipeline for deploying containers on ecs. The pipeline consists of the following stages.
   - Source: The Source stage has 2 actions which are executed in parallel. Action Source used for connecting codepipeline to github for source code and to store the code in s3 bucket codepipeline_bucket as SourceArtifact. Action GetDeployScripts is used for fetching deployment script from s3 bucket ecsbg_scriptbucket and store it as DeployScripts in s3 bucket codepipeline_bucket. 
   - Build: Stage for creating a new image and push it to ecr.Refers to the AWS CodeBuild project created by tf-coreservices.
   - Deploy: Stage to update task definition and ecs cluster service using codebuild project.Refers to the AWS CodeBuild project created by tf-coreservices.
   - ManageRelease: Stage to approve or reject deployment.Consists of two actions executed in serial.The first action ApproveRelease uses AWS CodePipeline provider Manual.The second action SwapTargetGroup invokes a lambda function upon approval to swap alb listener target group.Refers to the Lambda function created by tf-coreservices.
   - ManageRollback: Stage to rollback.
   
> This pipeline requires imagedefinitions.json file as an input to Deploy action. Refer to the sample builspec.yml file in the GitHub repo for generating the file imagedefinitions.json during build.

These type of resources are supported:

* [CODEPIPELINE](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline)

## Dependency
This module is dependent upon following modules
* [github.com/sgs-dxc/tf-aws-coreservices](https://github.com/sgs-dxc/tf-aws-coreservices) 
* [github.com/sgs-dxc/tf-aws-ecs](https://github.com/sgs-dxc/tf-aws-ecs)

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
data "aws_caller_identity" "current" {}
# Create the codepipeline for ECS continuous Deployment .  
module "codepipeline" {
  source = "github.com/sgs-dxc/tf-aws-codepipeline-ecs.git?ref=v1.1"
  region      = local.region
  env_prefix  = local.env_prefix
  repository_uri  = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-southeast-2.amazonaws.com/dxdemo"
  Owner           = "sgs-dxc"
  OAuthToken      = "03db3700c2a80dc06f45259830bd45"
  Repo            = "sample-ecs"
  Branch          = "release"
  # Following variables are depend on the ecs terraform module; 
  # replace ecs-module-name with actual module name.
  ElbName         = module.ecs-module-name.ElbName
  ClusterName     = module.ecs-module-name.ClusterName  
  TaskName        = module.ecs-module-name.TaskName
  BService        = module.ecs-module-name.BService
  GService        = module.ecs-module-name.GService
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
| env\_prefix | Creates a unique name for autoscaling group beginning with the specified prefix | `string` | `""` | Yes |
| repository\_uri | ECR image repo uri | `string` | `""` | Yes |
| Owner | Github username for connecting codepipeline to github | `string` | `""` | Yes |
| OAuthToken | Github user token for connecting codepipeline to github  | `string` | `""` | Yes |
| Repo | Github repository name | `string` | `""` | Yes |
| Branch | Repository branch name. | `string` | `""` | Yes |
| ElbName | AWS alb name created for ECS instances  | `string` | `""` | Yes |
| ClusterName | Name of the ECS Cluster   | `string` | `""` | Yes |
| BService | ECS Service Name for Production  | `string` | `""` | Yes |
| GService | ECS Service Name for Staging | `string` | `""` | Yes |
| TaskName | ECS Task definition name  | `string` | `""` | Yes |
| default\_tags | Default Tags | `list(map(string))` | `[]` | yes |

## AWS Codepipeline Outputs
| Name | Description |
|------|-------------|
| codepipeline_name | ECS Codepipeline Name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
