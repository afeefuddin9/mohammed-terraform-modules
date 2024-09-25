# tf-aws-ec2-codepipeline
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
  region = "us-west-2"
  ignore_tags {
    keys = ["Usage"]
  }
}
module "codepipeline" {
source = "./pipe"
env_prefix = "Test"
region = "us-west-2"
s3_bucket = "testing542216"
codedeploy_role = "arn:aws:iam::768502287836:role/LakshmiCodeDeploy"
codepipeline_role = "arn:aws:iam::768502287836:role/service-role/AWSCodePipelineServiceRole-ap-southeast-2-ECS-BlueGreen"
codebuild_role = "arn:aws:iam::768502287836:role/beanstalkbg-codebuild-role"
deployment_type = "IN_PLACE"
deployment_option = "WITHOUT_TRAFFIC_CONTROL"
deployment_config_name = "CodeDeployDefault.OneAtATime"
autoscaling_groups = ["testing"]
target_group = "Testing1"
#alarms = var.alarms
sns_topic_arn = "arn:aws:sns:us-west-2:768502287836:Lakshmi_test"
Owner = "sgs-dxc"
Branch = "main"
Repo = "TestRepo"
OAuthToken = var.token
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
| deployment_config_name | deployment_config type for deploying to ec2 instances | `string` | `""` | Yes |
| deployment_option | to define loadbalancer requirement | `string` | `""` | Yes |
| deployment_type | defining deployment type | `string` | `""` | Yes |
| autoscaling_groups | autoscaling_groups | `string` | `""` | Yes |
| target_group | target group name | `string` | `""` | Yes |
| trigger_events | trigger events to notify via SNS | `string` | `""` | Yes |
| alarms | cloudwatch alarm names | `string` | `""` | Yes |
| Repo | repo name | `string` | `""` | Yes |
| Branch | The branch name | `string` | `""` | Yes |
| Owner | The Owner name | `string` | `""` | Yes |
| OAuthToken | Define the token | `string` | `""` | Yes |
| codedeploy_role | Define the codedeploy role arn | `string` | `""` | Yes |
| codepipeline_role | Define the codepipeline role arn | `string` | `""` | Yes |
| codebuild_role | Define the codebuild role arn | `string` | `""` | Yes |
| sns_topic_arn | SNS topic arn | `string` | `""` | Yes |
| s3_bucket | s3 bucket name for articact store | `string` | `""` | Yes |
| Stage_Deploy_isEnabled | Define the boolean value to enable and disable the deploy stage | `string` | `""` | Yes |
| Stage_build_isEnabled | Define the boolean value to enable and disable the build stage | `string` | `""` | Yes |

| create_codedeploy_app | Define the boolean value to enable and disable the codedeploy app resource block | `string` | `""` | Yes |
| create_codebuild_project | Define the boolean value to enable and disable the codebuild project resource block | `string` | `""` | Yes |



<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
