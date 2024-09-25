# AWS VPC Terraform module

Terraform configuration to provision AWS VPC along with attached Internet Gateway, route table, egress rule to access the internet and a set of subnets. 

These types of resources are supported:

* [VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

## Terraform version
Terraform ~> 0.13.2

## Provider version
AWS Provider ~> 3.5.0

```hcl
# Provider Version Configuration
terraform {
  required_version = "~> 0.13.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.5.0"
    }
  }
}
provider "aws" {
  region = local.region
    ignore_tags {
    keys = ["Usage", "Usage-tag-source", "Usage-tag-update-time"]
  }
}
locals {
  #Define the application name ex: Vx, Digibot
  Application_Name = "TG-VPC-A"
  # Define the application stage ex: Prod, Pre-Prod, QA, Dev, Test
  Environment = "Test"
  envPrefix   = "${local.Application_Name}-${local.Environment}"
  region      = "us-west-2"

  default_tags = {
    Project = "dxplatform"
    Managed = "Terraform"
    Owner   = "dxplatform"
    Billing = "dxplatform"
    Environment = "${local.Environment}" # This tag should be set as project specific to better cost allocation
  }
  
 
}

# creates a VPC with two LoadBalancer subnets, two WEB subnets and two DB subnets   
module "VPC" {
  source                  = "github.com/sgs-dxc/tf-vpc.git?ref=v1.4"
  envPrefix               = local.envPrefix
  azs                     = "ap-southeast-2a,ap-southeast-2b"
  region            = local.region
  cidr                    = "10.9.0.0/23"
  lb_subnet_a_cidr        = "10.9.0.0/28"
  lb_subnet_b_cidr        = "10.9.0.32/28"
  db_subnet_a_cidr        = "10.9.0.64/27"
  db_subnet_b_cidr        = "10.9.0.96/27"
  web_subnet_a_cidr       = "10.9.0.128/27"
  web_subnet_b_cidr       = "10.9.0.160/27"
  default_tags            = local.default_tags
  enable_nat_gateway=false
  tg_rtb_blackhole=true
  vpc_peering=false

  # If enable_nat_gateway is false give the following details 
  transit_gateway_id = "tgw-0c7de1411889e6ed2"   # ID Valid only for POC account ap-southeast-1
  tg_app_route_table_id ="tgw-rtb-0996c4e49570c1576"  # ID Valid only for POC account ap-southeast-1
  tg_egress_route_table_id="tgw-rtb-05f68c752548d5ac1"  # ID Valid only for POC account ap-southeast-1
  egress_vpc_public_RT_id ="rtb-5ff14c39" # ID Valid only for POC account ap-southeast-1
  egress_vpc_tg_attachment_id="tgw-attach-0426db21f972f7def"  #ID Valid only for POC account ap-southeast-1

  #if vpc_peering is true update peering_cidr & peering_tg_attachement_id
  peering_cidr="10.12.0.0/23" # update the peering vpc cidr
  peering_tg_attachement_id="tgw-attach-0815ffe6d7b02503e" # update with peering vpc tg attachment id
  Note: for vpc communication after terraform apply need to update the active route at peering vpc tg route table with current vpc CIDR and update the respective security groups

  # enable_vpc_endpoint_dynamodb = true
  # enable_vpc_endpoint_s3 = true
  # Set the environment type to enable or disable vpc flowlogs(If the value is production, the VPC flow logs will be enabled)
  #environment_type = "production"
  #log_destination = "arn:aws:s3:::dxpf-vpc-flowlogs-sydney/VpcLogs/"
  # Code to create the additional private subnets
  prv_additional-subnet-mapping =  [  
    {
      name = "lambda_subnet_a"
      az   = "ap-southeast-2a"
      cidr = "10.9.0.192/27"
    },
    {
      name = "lambda_subnet_b"
      az   = "ap-southeast-2b"
      cidr = "10.9.0.224/27"
    }
      ]
  # Code to create the additional public subnets
  pub_additional-subnet-mapping = [
    {
      name = "jumpserver_subnet_a"
      az   = "ap-southeast-2a"
      cidr = "10.9.1.0/27"
    },
    {
      name = "jumpserver_subnet_b"
      az   = "ap-southeast-2b"
      cidr = "10.9.1.32/27"
    }
  ]
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

## VPC Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS Region where resources should be created  | `string` | `""` | Yes |
| envPrefix | To define environment Prefix  | `string` | `""` | Yes |
| azs | comma separated ordered lists of (two) AZs in which to distribute subnets | `string` | `""` | Yes |
| enable_dns_hostnames | Boolean value whether we need to enable dns hostnames  | `Boolean` | `"true"` | Yes |
| enable_dns_support | Boolean value whether we need to enable dns support | `Boolean` | `"true"` | Yes |
| cidr | define the VPC cidr block | `string` | `""` | Yes |
| lb_subnet_a_cidr | Defines the lb subnet_a cidr block | `string` | `""` | Yes |
| lb_subnet_b_cidr | Defines the lb subnet_b cidr block | `string` | `""` | Yes |
| db_subnet_a_cidr | Defines the db subnet_a  cidr block | `string` | `""` | Yes |
| db_subnet_b_cidr | Defines the db subnet_b cidr block | `string` | `""` | Yes |
| web_subnet_a_cidr | Defines the web subnet_a cidr block | `string` | `""` | Yes |
| web_subnet_b_cidr | Defines the web subnet_b cidr block | `string` | `""` | Yes |
| enable_db_subnet_group | Set to true to create database subnet group for RDS | `Boolean` | `"false"` | Yes |
| default_tags | Set the default values | `map(string)` | `"false"` | Yes |
| prv_additional-subnet-mapping | Lists the private subnets to be created in their respective AZ | `Boolean` | `"[]"` | Yes |
| pub_additional-subnet-mapping | Lists the public subnets to be created in their respective AZ | `Boolean` | `"[]"` | Yes |

## VPC Outputs

| Output Variable | Description |
|-----------------|-------------|
| vpc_id | The ID of the VPC created. |  
| lb_subnet_a_id | The ID of the load balancer subnet A |
| lb_subnet_b_id | The ID of the load balancer subnet B |
| web_subnet_a_id | The ID of the web subnet A |
| web_subnet_b_id |The ID of the web subnet B |
| db_subnet_a_id | The ID of the DB subnet A |
| db_subnet_b_id | The ID of the DB subnet B |
| public_subnet_id | The ID of the additional public subnet |
| private_subnet_id | The ID of the additional private subnet |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
