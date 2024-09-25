# AWS Elastic Container Service (ECS) Fargate launch type Terraform module (Blue/Green Deployment option disabled by default)

Terraform module to Task Definition, ECS Cluster and Services required for deploying containers on AWS ECS. 
This configuration doesn’t create the AWS ECR repository required for storing the docker images. The ECR repository needs to be created manually and image pushed into it before running this configuration.

These type of resources are supported:

* [ECS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster)

## Terraform version
Terraform ~> 1.3.0

## Provider version
AWS Provider ~> 4.5

## Configuration Usage

```hcl
# Provider Version Configuration
terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = ">= 4.5"
  }
}
provider "aws" {
  region = local.region
  ignore_tags {
    keys = ["Usage", "Usage-tag-source", "Usage-tag-update-time"]
  }
}
locals {
  # Define the application name ex: VxProd, DigibotQa
  Application_Name = "dxplatform"
  # Define the application stage ex: QA, testing, production
  Environment = "Test"
  envPrefix   = "${local.Application_Name}-${local.Environment}"
  region      = "us-west-2"

  default_tags = {
    Project     = "dxplatform"
    Managed     = "Terraform"
    Owner       = "dxplatform"
    Billing     = "dxplatform"
    Environment = "${local.Environment}" # This tag should be set as project specific to better cost allocation
  }
  fargate_container_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-southeast-2.amazonaws.com/lakshmi-test-ecs:latest"
  fargate_container_port  = "80"
  fargate_log_group_name  = "/aws/ecs/dxpf-fargate"
  fargate_num_of_tasks    = "1"
  fargate_cpu             = "256"
  fargate_memory          = "512"
}
data "aws_caller_identity" "current" {}
module "ecs_Fargate" {
  source                = "github.com/sgs-dxc/tf-aws-ecs-fargate?ref=v1.0"
  region                = local.region
  env_prefix            = local.envPrefix
  container_definitions = <<EOF
[
 {
   "name": "${local.envPrefix}",
   "networkMode": "awsvpc",
   "image": "${local.fargate_container_image}",
   "essential": true,
    "logConfiguration": {
        "logDriver": "awslogs",
             "options": {
                "awslogs-region": "${local.region}",
                "awslogs-group": "${aws_cloudwatch_log_group.cloudwatch_log_group.name}",
                "awslogs-stream-prefix": "${aws_cloudwatch_log_stream.cloudwatch_log_stream_app.name}"
             }
      },
   "portMappings":
            [
             {
                 "containerPort": ${local.fargate_container_port},
                 "hostPort": ${local.fargate_container_port}
             }
            ]
 }
]
 EOF
  #create_bluegreen = true
  num_of_tasks          = local.fargate_num_of_tasks
  container_image       = local.fargate_container_image
  container_port        = local.fargate_container_port
  log_group_name        = "/aws/ecs"
  fargate_cpu           = local.fargate_cpu
  fargate_memory        = local.fargate_memory
  security_groups_ids   = [module.custom_sg.app_sg]
  vpc_id                = module.VPC.vpc_id
  target_group_arn1     = module.ALB.target_group_arns1
  target_group_arn2     = module.ALB.target_group_arns2
  listener1             = module.ALB.target_group_listener_arn
  listener2             = module.ALB.target_group_listener_arn
  subnet_ids            = [module.VPC.web_subnet_a_id, module.VPC.web_subnet_b_id]
  default_tags          = local.default_tags
  sns_topic_arn = module.sns-email-topic.arn
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
| aws | ~> 4.5 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 4.5 |

## ECS Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS Region where resources should be created | `string` | `""` | Yes |
| env_prefix | project prefix for ecs environment| `string` | `""` | Yes |
| fargate_cpu | Required CPU for fargate| `string` | `""` | Yes |
| fargate_memory | Required Memory for fargate | `string` | `""` | Yes |
| log_group_name | Cloud Watch Log Group name | `string` | `"/aws/ecs"` | Yes |
| region | AWS region| `string` | `""` | Yes |
| container_port | container port number| `string` | `""` | Yes |
| container_image | container image uri| `string` | `""` | Yes |
| num_of_tasks | number of tasks for a service| `string` | `""` | Yes |
| default_tags | to define the default tags | `map(string)` | `""` | Yes |
| prod_tags | tag to identify prod env | `map(string)` | `"{ "IsProduction" : "True" }"` | Yes |
| log_retention_days | Cloud Watch Log Group retention days| `string` | `"30"` | Yes |
| vpc_id | VPC Id | `string` | `""` | Yes |
| subnet_ids | the subnet id's to be associated | `list(string)` | `""` | Yes |
| security_groups_ids | the subnet id's to be associated  | `list(string)` | `""` | Yes |
| assign_public_ip | whether to assign the public IP or not | `Boolean` | `"false"` | Yes |
| target_group_arn1 | the target group arn for service 1| `string` | `""` | Yes |
| create_bluegreen | Boolean value whether to create bluegreen deployment or not | `Boolean` | `"false"` | Yes |
| target_group_arn2 | the target group arn for service 2 | `string` | `"null"` | Yes |

## Outputs
| Name | Description |
|------|-------------|
| ClusterName | ECS cluster name |
| BService | ECS Blue Deployment service name |
| GService | ECS Green Deployment service name |
| TaskName | Task Definition name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
