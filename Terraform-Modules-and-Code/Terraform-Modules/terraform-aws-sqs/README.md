# AWS SQS Terraform module

Terraform module to create the SQS queue on AWS.

These types of resources are supported:

* [SQS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs)

## Terraform version
Terraform ~> 0.13.2

## Provider version
AWS Provider ~> 3.5.0

## Configuration Usage

```hcl
# Provider Version Configuration
provider "aws" {
  region = "ap-southeast-2"
  ignore_tags {
    keys = ["Usage"]
  }
}
locals {
  region = "ap-southeast-2"
  default_tags = {
    Project = "DxInfra"
    Managed = "Terraform"
    Owner   = "Dx"
    Billing = "Dx" # This tag should be set as project specific to better cost allocation
  }
  envPrefix        = "testing_SQS"
}
# Create Application Load Balancer and Target Group.
module "SQS" {
  # Refer the github release version for details features details. 
  source       = "./SQS"
  region       = local.region
  default_tags = local.default_tags
  queue_name = local.env_prefix
  max_message_size                  = 2048
  delay_seconds                     = 90
  receive_wait_time_seconds         = 10
  message_retention_seconds = 432000
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

## SQS Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS Region where resources should be created | `string` | `""` | Yes |
| queue_name | Name of the queue | `string` | `""` | Yes |
| default_tags | The default tags to attach as tags | `string` | `""` | Yes |
| message_retention_seconds | The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days). | `number` | `""` | Yes |
| max_message_size | The limit of how many bytes a message can contain before Amazon SQS rejects it.  | `string` | `""` | Yes |
| delay_seconds | The time in seconds that the delivery of all messages in the queue will be delayed.  | `string` | `""` | Yes |
| receive_wait_time_seconds | The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds). | `string` | `""` | Yes |
| fifo_queue | Boolean designating a FIFO queue. | `string` | `""` | Yes |
| content_based_deduplication | Enables content-based deduplication for FIFO queues. | `boolean` | `""` | Yes |


## SQS Outputs

| Name | Description |
|------|-------------|
| queue_id | The sqs queue id |
| queue_arn | The sqs queue arn |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
