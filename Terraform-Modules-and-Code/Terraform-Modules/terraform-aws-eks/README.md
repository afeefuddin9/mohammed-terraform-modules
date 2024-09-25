# AWS EKS Terraform module

Terraform module which creates EKS cluster and nodes.

These types of resources are supported:

* [EKS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks)

## Terraform version
Terraform ~> 0.13.2

## Provider version
AWS Provider ~> 3.5.0

## Configuration Usage

```hcl
terraform {
  required_version = ">= 0.13.2"
  required_providers {
    aws = ">= 3.5.0"
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
  Application_Name = "EKS"
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

module "eks-cluster" {
  source     = "./terraform-aws-eks"
  env_prefix = local.envPrefix
  ng_name    = "node-group"
  #lt_security_groups = []
  region                               = local.region
  BillingTag                           = "dxplatform"
  NameTag                              = "dxplatform"
  Volume_NameTag                       = "dxplatform"
  OwnerTag                             = "dxplatform"
  instance_type                        = "t2.medium"
  key_name                             = "dxpf-test"
  cluster_name                         = "${local.envPrefix}-tf-module"
  cluster_subnets                      = [module.vpc.lb_subnet_a_id, module.vpc.lb_subnet_b_id]
  ng_subnets                           = [module.vpc.web_subnet_a_id, module.vpc.web_subnet_b_id]
  default_tags                         = local.default_tags
  image_id                             = "ami-0bf2320c57e83e37f"
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["125.16.140.50/32"]
  #cluster_additional_sg=[aws_security_group.eks_cluster_additional_sg.id]
  #sec_grp =[aws_security_group.eks_cluster_additional_sg.id,aws_security_group.node_group_sg.id]
  #userDataDetails = filebase64("./user_data/user_data.sh")
  #configmap_roles=local.configmap_roles
  vpc_id = module.vpc.vpc_id
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

## Application Load Balancer Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS Region where resources should be created  | `string` | `""` | Yes |
| env\_prefix | Creates a unique name for Application Load Balancer beginning with the specified prefix | `string` | `""` | Yes |
| environment\_name |Deployment environment name, eg: Dev, QA or Production  | `string` | n/a | Yes |
| vpc\_id | VPC ID in which ALB will be created | `string` | `""` | Yes |
| alb\_subnet1, alb\_subnet2 | Public Subnet ID's for ALB  | `string` | `""` | Yes |
| alb\_security\_grp, alb\_security\_grp\_01, alb\_security\_grp\_02 | Security Groups for ALB  | `string` | `""` | Yes |
| alb\_certificate\_arn | SSL Certificate ARN for ALB   | `string` | `""` | Yes |
| s3\_bucket | S3 Bucket Name for ALB Access Logs Configuration | `string` | `""` | no |
| default\_tags | Default Tags | `list(map(string))` | `[]` | Yes |

## Application Load Balancer Outputs
| Name | Description |
|------|-------------|
| alb\_id |The ID of the Application load balancer created. |
| alb\_arn |The ARN of the Application load balancer created. |
| alb\_dns\_name |The DNS name of the load balancer. |
| target\_group\_arns |ARNs of the target groups. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
