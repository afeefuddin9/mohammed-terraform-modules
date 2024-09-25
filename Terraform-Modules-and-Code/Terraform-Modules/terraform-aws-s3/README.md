# AWS S3 Terraform module

Terraform module to create the S3 bucket on AWS.

These types of resources are supported:

* [S3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3)

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
    keys =  ["Usage", "Usage-tag-source", "Usage-tag-update-time"]
  }
}
locals {

  Application_Name = "DxPlatform"
  # Define the application stage ex: Prod,Pr-Prod, QA, Dev,Stable and Test
  Environment      = "Test"
  region = "us-west-2"

  
  envPrefix           = "${local.Application_Name}-${local.Environment}" 
  default_tags = {
    Project     = "dxplatform"
    Managed     = "Terraform"
    Billing     = "dxplatform" # This tag should be set as project specific to better cost allocation
    Owner       = "dxplatform"
    Environment = "${local.Environment}"
  }
 
}
module "s3_module" {
  source = "app.terraform.io/dxc-dxpf/s3/aws"
  version = "1.2.1"
  envPrefix = local.envPrefix
  Environment =local.Environment
  region = local.region
  default_tags = local.default_tags
  bucket-name = lower("${local.envPrefix}-S3-Bucket-Name")
  enable_versions = "true"
  enable_lifecycle = "false"
  replication_role = "false"
  create_replication_bucket = "false"
  #replication-bucket-name = "testbucket216420"
  #dest_bucket_arn = ""
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

## S3 Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region  | the region name | `string` | n/a | yes |
| bucket-name  | the default tags | `string` | n/a | yes |
| default_tags  | the default tags | `string` | n/a | yes | 
| enable_versions | Boolean value to set versioning | `string` | n/a | yes |
| enable_lifecycle | Boolean value to set lifecycle | `string` | false | yes |
| restrict_public | Boolean value to set the public access | `string` | n/a | yes |

## S3 Outputs

| Name | Description |
|------|-------------|
| s3-bucket | The s3 bucket ID |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
