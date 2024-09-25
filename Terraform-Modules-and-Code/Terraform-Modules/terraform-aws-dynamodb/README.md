# AWS DynamoDB Terraform module

Terraform module which creates the DynamoDb Table on AWS.

These types of resources are supported:

* [DynamodDB Table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table)

## Terraform version
Terraform ~> 1.3.0

## Provider version
AWS Provider ~> 4.0

## Configuration Usage

```hcl
# Provider Version Configuration
provider "aws" {
  region = local.region
  ignore_tags {
    keys = ["Usage", "Usage-tag-source", "Usage-tag-update-time"]
  }
}
terraform {
  required_version = "~> 1.3.0"
   required_providers {
    aws = "~> 4.0"
    }
}
# Set the local variables
locals {
  region = "us-west-2"
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

# Provider Version Configuration
provider "aws" {
  region = local.region
  ignore_tags {
    keys =  ["Usage"]
  }
}
terraform {
  required_version = "~> 0.13.0"
   required_providers {
    aws = "~> 3.5.0"
}
}
module "dynamodb_table" {
  source      = "github.com/sgs-dxc/tf-aws-dynamodb.git?ref=v1.0"
  Environment = local.Environment
  region      =local.region
  envPrefix   = local.envPrefix
  hash_key    = "id"

  attributes = [
    {
      name = "id"
      type = "N"
    }
  ]

tags = local.tags
point_in_time_recovery_enabled = "true"
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
| terraform | ~> 1.3.0 |
| aws | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 4.0 |

## DynamoDB Module Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | the region of the db | 'string' | `""` | Yes |
| create_table | Controls if DynamoDB table and associated resources are created | 'boolean' | 'true' | Yes |
| envPrefix | The environment prefix | 'boolean' | 'true' | Yes |
| attributes | List of nested attribute definitions. Only required for hash_key and range_key attributes. Each attribute has two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data | 'list'(map(string)) | '[ ]' | Yes |
| hash_key | The attribute to use as the hash (partition) key. Must also be defined as an attribute | 'string' | 'null' | Yes |
| range_key | The attribute to use as the range (sort) key. Must also be defined as an attribute | 'string' | 'null' | Yes |
| billing_mode | Controls how you are billed for read/write throughput and how you manage capacity. The valid values are PROVISIONED or PAY_PER_REQUEST | 'string' | 'PAY_PER_REQUEST' | Yes |
| write_capacity | The number of write units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0 | 'number' | 'null' | Yes |
| read_capacity | The number of read units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0 | 'number' | 'null' | Yes |
| point_in_time_recovery_enabled | Whether to enable point-in-time recovery | 'boolean' | 'false' | Yes |
| ttl_enabled | Indicates whether ttl is enabled | 'boolean' | 'false' | Yes |
| ttl_attribute_name | The name of the table attribute to store the TTL timestamp in | 'string' | '""' | Yes |
| replica_regions | Region names for creating replicas for a global DynamoDB table. | 'list'(string) | '[ ]' | Yes |
| stream_enabled | Indicates whether Streams are to be enabled (true) or disabled (false). | 'boolean' | 'false' | Yes |
| stream_view_type | When an item in the table is modified, StreamViewType determines what information is written to the table's stream. Valid values are KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES. | 'string' | 'null' | Yes |
| server_side_encryption_enabled | Whether or not to enable encryption at rest using an AWS managed KMS customer master key (CMK) | 'boolean' | 'true' | Yes |
| tags | A map of tags to add to all resources | 'map'(string) | Yes |
| timeouts | Updated Terraform resource management timeouts | 'map'(string) | Yes |


## DynamoDb Module Outputs
| Name | Description |
|------|-------------|
| dynamoDB_id | The ID of the dynamoDB |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
