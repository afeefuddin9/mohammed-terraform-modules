# AWS DocumentDB Terraform module

Terraform module which creates DocumentDB on AWS.

These types of resources are supported:

* [DocumentDB](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster)

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
}
locals {
  ######## Start of GLOBAL variables (Need to change every values as per the project requirements including the default tags) ########
  region = "ap-southeast-2"

  # Define the application name along with environment ex: VxProd, DigibotQa
  application_name = "Dx-dev"

  # Define the application stage ex: QA, testing, production
  envPrefix = local.application_name

  default_tags = {
    Project = "Dx-dev"
    Managed = "Terraform"
    Owner   = "dxplatform"
    Billing = "dxplatform" # This tag should be set as project specific to better cost allocation
  }
  cluster_size           = 2
  identifier             = local.envPrefix
  secret_id              = "Testing"
  instance_class         = "db.t3.medium"
  db_port                = "27017"
  vpc_cidr_block         = "172.31.0.0/16"
  vpc_security_group_ids = ["sg-0161ec956c94940b7", "sg-01eb2e50df8b746d1"]
  allowed_cidr_blocks    = ["172.31.96.0/19"]
  retention_period       = 7
  availability_zones     = ["ap-southeast-2b", "ap-southeast-2c"]
  cluster_parameters = [{
    apply_method = "pending-reboot"
    name         = "tls"
    value        = "enabled"
  }]
  subnet_ids                      = ["subnet-6c72c534", "subnet-7c67631b"]
  cluster_family                  = "docdb4.0"
  engine                          = "docdb"
  engine_version                  = "4.0.0"
  enabled_cloudwatch_logs_exports = ["audit", "profiler"]
  your_secret = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}
# Calling the secrete
data "aws_secretsmanager_secret_version" "creds" {
  # write your secret name here
  secret_id = local.secret_id
}
module "documentdb_cluster" {
  source       = "./Document_DB"
  cluster_size = local.cluster_size

  # Set the secrets from AWS Secrets Manager
  master_username = local.your_secret.username
  master_password = local.your_secret.password
  region          = local.region
  instance_class  = local.instance_class
  db_port         = local.db_port
  subnet_ids      = local.subnet_ids
  #apply_immediately               = local.apply_immediately
  #auto_minor_version_upgrade      = local.auto_minor_version_upgrade
  vpc_security_group_ids = local.vpc_security_group_ids
  allowed_cidr_blocks    = local.allowed_cidr_blocks
  retention_period       = local.retention_period
  availability_zones     = local.availability_zones
  envPrefix              = local.envPrefix
  vpc_cidr_block         = local.vpc_cidr_block
  identifier             = local.identifier
  #preferred_backup_window         = local.preferred_backup_window
  #preferred_maintenance_window    = local.preferred_maintenance_window
  cluster_parameters = local.cluster_parameters
  cluster_family     = local.cluster_family
  engine             = local.engine
  engine_version     = local.engine_version
  #storage_encrypted               = local.storage_encrypted
  #kms_key_id                      = local.kms_key_id
  #skip_final_snapshot             = local.skip_final_snapshot
  enabled_cloudwatch_logs_exports = local.enabled_cloudwatch_logs_exports
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

## DocumentDB Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS Region where resources should be created  | `string` | `""` | Yes |
| env\_prefix | Creates a unique name for Application Load Balancer beginning with the specified prefix | `string` | `""` | Yes |
| availability\_zones | List of availability zones | `list(string)` | n/a | Yes |
| vpc\_cidr\_block | The VPC CIDR block | `string` | `""` | Yes |
| identifier | Define the identifier of the Cluster  | `string` | `""` | Yes |
| deletion\_protection | The boolean value to enable deletion protection  | `bool` | `""` | Yes |
| vpc_security\_group\_ids | List of existing Security Groups to be allowed to connect to the DocumentDB cluster   | `string` | `""` | Yes |
| allowed\_cidr\_blocks | List of CIDR blocks to be allowed to connect to the DocumentDB cluster | `string` | `""` | no |
| subnet\_ids | List of subnet IDs to be allowed to connect to the DocumentDB cluster | `list(string)` | `[]` | Yes |
| instance_class | List of CIDR blocks to be allowed to connect to the DocumentDB cluster | `string` | `""` | no |
| cluster_size | List of CIDR blocks to be allowed to connect to the DocumentDB cluster | `string` | `""` | no |
| db_port | List of CIDR blocks to be allowed to connect to the DocumentDB cluster | `string` | `""` | no |
| master_username | List of CIDR blocks to be allowed to connect to the DocumentDB cluster | `string` | `""` | no |
| master_password | List of CIDR blocks to be allowed to connect to the DocumentDB cluster | `string` | `""` | no |
| retention_period | List of CIDR blocks to be allowed to connect to the DocumentDB cluster | `string` | `""` | no |
| cluster_parameters | List of DB parameters to apply | `string` | `""` | no |
| cluster_family | The family of the DocumentDB cluster parameter group | `string` | `""` | no |
| default_tags | Define the default tags to the cluster | `string` | `""` | no |
| engine | The name of the database engine to be used for this DB cluster. Defaults to `docdb`. Valid values: `docdb` | `string` | `""` | no |
| engine_version | The version number of the database engine to use | `string` | `""` | no |
| enabled_cloudwatch_logs_exports | List of log types to export to cloudwatch. The following log types are supported: `audit`, `error`, `general`, `slowquery` | `string` | `""` | no |

## DocumentDB Outputs
| Name | Description |
|------|-------------|
| arn |The arn of the DocumentDB created. |
| endpoint | Endpoint of the DocumentDB cluster |
| reader_endpoint | Read-only endpoint of the DocumentDB cluster, automatically load-balanced across replicas |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
