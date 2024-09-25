
# SNS Topic - Email

Terraform Module for SNS Topic and List of Emails

## Introduction

Terraform supports most AWS SNS resource options except for email protocols. Because the email needs to be
confirmed, it becomes out of the normal bounds of the terraform model so it does not support it. 

This module creates an SNS email topic via a CloudFormation that outputs the ARN for use elsewhere. 

These type of resources are supported:

* [SNS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)

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
}
locals {
  ######## Start of GLOBAL variables (Need to change every values as per the project requirements including the default tags) ########
  region = "us-west-2"

  # Define the application name along with environment ex: Bliss, Digibot
  Application_Name = "DxPlatform"
  Environment      = "Test"

  # Define the application stage ex: QA, testing, production
  envPrefix           = "${local.Application_Name}-${local.Environment}"
  alarm_sns_topic_arn = "arn:aws:sns:us-west-2:768502287836:Lakshmi_test:67d9ef4e-2029-485b-b0b9-785e0192335c"
  default_tags = {
    Project     = "dxplatform"
    Managed     = "Terraform"
    Billing     = "dxplatform" # This tag should be set as project specific to better cost allocation
    Owner       = "dxplatform"
    Environment = "${local.Environment}"
  }
}
module "sns-email-topic" {
  source          = "github.com/sgs-dxc/tf-sns-email"
  Environment     = local.Environment
  envPrefix       = local.envPrefix
  region          = local.region
  display_name    = "AutoScale Events"
  email_addresses = ["user1@sony.com", "user2@sony.com"]
  stack_name      = "sns-stack-name"
  default_tags    = local.default_tags
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


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| display_name | Name shown in confirmation emails | string | - | yes |
| email_addresses | Email address to send notifications to | list | - | yes |
| protocol | SNS Protocol to use, for email use - email or email-json | string | `email` | no |
| stack_name | Unique Cloudformation stack name that wraps the SNS topic. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | Email SNS topic ARN |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Author

Module managed by [Sony DXC Platform](https://).