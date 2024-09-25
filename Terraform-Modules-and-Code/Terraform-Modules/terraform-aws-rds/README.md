# AWS RDS Terraform module

Terraform module which creates the RDS MySql database instance on AWS.

These types of resources are supported:

* [RDS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)

## Terraform version
Terraform ~> 0.13.0

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
    keys = ["Usage"]
  }
}

# Set the local variables
locals {
  envPrefix = "terraform-rdstest"
  region = "ap-southeast-2"
  secret_id = "Testing"
  your_secret = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
  default_tags = {
    Project = "dxplatform"
    Managed = "Terraform"
    Owner   = "dxplatform"
    Billing = "dxplatform" # This tag should be set as project specific to better cost allocation
  }
}

# Calling the secrete
data "aws_secretsmanager_secret_version" "creds" {
  # write your secret name here
  secret_id = local.secret_id
}
# Creates the rds mysql db instance
module "rds" {
source = "./tf-aws-rds"
region = local.region
envPrefix = local.envPrefix
default_tags = local.default_tags

db_name = "testingRds"
identifier = "test-rds-identifier"
parameter_group_name = "default.mysql5.7"
aws_db_subnet_group_name = "testrds"

# Set the secrets from AWS Secrets Manager
username = local.your_secret.username
password = local.your_secret.password

engine = "mysql"
engine_version = "5.7"
instance_class = "db.t2.micro"
allow_major_version_upgrade = "true"
auto_minor_version_upgrade = "true"

allocated_storage = "20"
storage_type = "gp2"
storage_encrypted    = true

rds_subnet1 = "subnet-7c67631b"
rds_subnet2 = "subnet-6c72c534"
multi_az = "true"
rds-sg = ["sg-0b2dacb78a2840d34"]

backup_retention_period = "35"
backup_window = "22:00-23:00"
maintenance_window = "Sat:00:00-Sat:03:00"

skip_final_snapshot = "true"
publicly_accessible = "false"
deletion_protection = "true"
log_exports_type = ["audit", "error", "general", "slowquery"]
rds_sns_topic = "arn:aws:sns:ap-southeast-2:768502287836:Lakshmi_Tripura"
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
| terraform | ~> 0.13.0 |
| aws | ~> 3.5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.5.0 |

## RDS(MySql) Module Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | the region of the db | 'string' | `""` | Yes |
| envPrefix | defines the env prefix | 'string' | `""` | Yes |
| db_name | the db name | 'string' | `""` | Yes |
| identifier | the unique db identifier | 'string' | `""` | Yes |
| parameter_group_name | the parameter group name that need to used for db | 'string' | `""` | Yes |
| username | the db username | 'string' | `""` | Yes |
| ssm_parameter_name | ssm parameter name that contains database password | 'string' | `""` | Yes |
| engine | the db engine name | 'string' | `""` | Yes |
| engine_version | the db engine version | 'string' | `""` | Yes |
| instance_class | the db instance class | 'string' | `""` | Yes |
| allow_major_version_upgrade | boolean value to allow major version upgrade | 'string' | `"true"` | Yes |
| auto_minor_version_upgrade | boolean value to allow minor version upgrade | 'string' | `"true"` | Yes |
| allocated_strorage | the storage that should be allocated | 'string' | `""` | Yes |
| storage_type | the type of the storage | 'string' | `""` | Yes |
| rds_subnet1 | the subnet id for db subnet group | 'string' | `""` | Yes |
| rds_subnet2 | the subnet id for db subnet group | 'string' | `""` | Yes |
| multi_az  | boolean value to enable the multi az | 'string' | `"true"` | Yes |
| rds-sg | the securities group id's of the rds | 'list(string)' | `""` | Yes |
| backup_retention_period | the backup retention peroid | 'string' | `"35"` | Yes |
| backup_window | the backup timings | 'string' | `"22:00-23:00"` | Yes |
| maintenance_window | the timings to perform the maintenance | 'string' | `"Sat:00:00-Sat:03:00"` | Yes |
| skip_final_snapshot | boolean value to skip the final snapshot | 'string' | `"false"` | Yes |
| publicly_accessible | boolean value to define whether public access needed or not | 'string' | `"false"` | Yes |
| deletion_protection | Boolean value to enable the deletion protection | 'string' | `"true"` | Yes |
| log_exports_type | the type of logs needs to be stored | 'list(string)' | `""` | Yes |
| rds_sns_topic | name of the sns topic | 'string' | `""` | Yes |




## RDS(MySql) Module Outputs
| Name | Description |
|------|-------------|
| rds_identifier |The ID of the RDS |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
