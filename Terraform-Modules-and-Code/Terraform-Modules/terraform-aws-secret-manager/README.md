# AWS secret manager Terraform module

Terraform module to create the Secret on AWS.

These types of resources are supported:

* [Secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret)

## Terraform version
Terraform ~> 2.7.0

## Provider version
AWS Provider ~> 4.13.0

## Configuration Usage

```hcl
# Provider Version Configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
    }
    github = {
      source  = "integrations/github"
      version = "4.13.0"
    }
  }
}
# Provider Details
provider "aws" {
  region = local.region
  ignore_tags {
    keys = ["Usage", "Usage-tag-source", "Usage-tag-update-time"]
  }
}
locals  {
  region     = "us-west-2"
}
module "tf-aws-secret-manager" {
  source = "./tf-aws-secret-manager"
  name            = "my-secret"
  secret_string   = jsonencode({
      DB_HOST     = "db.example.com",
      DB_USER     = "user",
      DB_PASSWORD = "password"
  })
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
| terraform | ~> 2.7.0 |
| aws | ~> 4.13.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~>4.13.0 |

## Secret Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region  | the region name | `string` | n/a | yes |
| secret-name  | the default tags | `string` | n/a | yes |



## Secret Outputs

| Name | Description |
|------|-------------|
| secret | aws_secretsmanager_secret.my-secret|

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
