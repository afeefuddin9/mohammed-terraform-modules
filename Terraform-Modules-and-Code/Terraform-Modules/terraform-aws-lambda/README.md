# AWS Lambda Terraform module

Terraform module to create the Lambda function on AWS.

These types of resources are supported:

* [Lambda Function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)

## Terraform version
Terraform ~> 0.13.2

## Provider version
AWS Provider ~> 3.5.0

## Configuration Usage

```hcl
# Provider Version Configuration
provider "aws" {
  region = "us-west-2"
  ignore_tags {
    keys = ["Usage"]
  }
}
locals {
  region = "us-west-2"
  default_tags = {
    Project = "DxInfra"
    Managed = "Terraform"
    Owner   = "Dx"
    Billing = "Dx" # This tag should be set as project specific to better cost allocation
  }
  envPrefix        = "testing_lambda"
  environment_name = "production"
}
module "lambda" {
  source             = "./Lambda"
  lambdaFunctionName = local.envPrefix
  subnet_id          = ["subnet-6d605937"] 
  sg_id              = ["sg-0631977bcc375c672"]
  default_tags       = local.default_tags
  maximum_event_age_in_seconds = "21600"
  layer_name = local.envPrefix
  role_arn = "arn:aws:iam::768502287836:role/Merging_alerts_reports_IAM_ROLE"
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

## Lambda Function Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_vpc  | Define Boolean value to enable or disable VPC | `string` | n/a | No |
| lambdaFunctionName  | Defines the lambda function name | `string` | n/a | yes |
| subnet_id  | The list of subnets id for lambda | `list(string)` | n/a | yes |
| sg_id  | The security group id of lambda | `list(string)` | n/a | yes |
| runtime  | The runtime of the lambda to create | `string` | n/a | yes |
| handler  | The handler name of the lambda (a function defined in your lambda) | `string` | n/a | yes |
| memory_size  | The memory size of the lambda | `string` | n/a | yes |
| lambda_timeout  | The lambda timeout | `string` | n/a | yes |
| concurrency  | Define the concurrency value | `string` | n/a | yes |
| log_retention  | Define the log retention period | `string` | n/a | yes |
| env_vars  | A map that defines environment variables for the Lambda Function. | `string` | n/a | yes |
| default_tags  | Define the default tags | `string` | n/a | yes |
| create_lambda_layer  | Boolean value to create lambda layer | `string` | n/a | No |
| layer_name  | Defines the layer names | `string` | n/a | yes |
| create_event_invoke  | Boolean value to create event invoke conditionally | `string` | n/a | No |
| maximum_event_age_in_seconds  | Define the maximum event age in seconds | `string` | n/a | yes |
| maximum_retry_attempts  | Define the maximum retry attempts | `string` | n/a | yes |
| role_arn  | Define the role arn for lambda | `string` | n/a | yes |

## Lambda Function Outputs

| Name | Description |
|------|-------------|
| function_name | The Lambda function arn |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
