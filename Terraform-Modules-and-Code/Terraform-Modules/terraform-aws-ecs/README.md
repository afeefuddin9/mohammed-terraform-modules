# AWS Elastic Container Service (ECS) Terraform module (Blue/Green Deployment option by default)

Terraform module to create ALB, Target groups, ALB listeners, Task Definition, ECS Cluster and Services required for deploying containers on AWS ECS. 
This configuration doesn’t create the AWS ECR repository required for storing the docker images. The ECR repository needs to be created manually and image pushed into it before running this configuration.

These type of resources are supported:

* [ALB](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)
* [ASG](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)
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
  #ECS Module
  container_image  = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-southeast-2.amazonaws.com/lakshmi-test-ecs:latest"
  container_port   = "80"
  log_group_name   = "/aws/ecs/dxpf-esc"
  Container_cpu    = "10"
  Container_Memory = "512"
  num_of_tasks     = "5"
}
data "aws_caller_identity" "current" {}
module "ecsapp" {
  source                = "github.com/sgs-dxc/tf-aws-ecs.git?ref=v1.1"
  region                = local.region
  env_prefix            = local.envPrefix
  iam_role              = module.IAM.ecs_service_name
  vpc_id                = module.VPC.vpc_id
  alb_target_group1     = module.ALB.target_group_arns1
  listener1             = module.ALB.target_group_listener_arn
  listener2             = module.ALB.target_group_listener_arn2
  alb_target_group2     = module.ALB.target_group_arns2
  ecs_subnet1           = module.VPC.web_subnet_a_id
  ecs_subnet2           = module.VPC.web_subnet_b_id
  num_of_tasks          = local.num_of_tasks
  container_port        = local.container_port
  container_definitions = <<EOF
[ {
   "name": "${local.envPrefix}",
   "image": "${local.container_image}",
   "cpu": ${local.Container_cpu},
   "memory": ${local.Container_Memory},
   "essential": true,
    "logConfiguration": {
        "logDriver": "awslogs",
             "options": {
                "awslogs-region": "${local.region}",
                "awslogs-group": "${local.log_group_name}",
                "awslogs-stream-prefix": "${local.envPrefix}"
             }
      },
   "portMappings": [{
                 "containerPort": ${local.container_port},
                 "hostPort": 0
             }
            ]
 }]
 EOF
  default_tags          = local.default_tags
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
| env\_prefix | Creates a unique name for autoscaling group beginning with the specified prefix | `string` | `""` | Yes |
| vpc\_id | VPC id for the project  | `string` | `""` | Yes |
| alb\_subnet1 | Public subnet for the Load Balancer at zone a  | `string` | `""` | Yes |
| alb\_subnet2 | Public subnet for the Load Balancer at zone b  | `string` | `""` | Yes |
| alb\_access\_log\_enable | Enable the access logs on Application Load Balancer | `string` | `""` | Yes |
| alb\_access\_log\_bucket | S3 bucket name where access logs will be stored. | `string` | `""` | Yes |
| alb\_certificate\_arn | SSL Certificate ARN for https listener  | `string` | `""` | Yes |
| ecs\_subnet1 | Private subnet for ECS instance (EC2) zone a  | `string` | `""` | Yes |
| ecs\_subnet2 | Private subnet for ECS instance (EC2) zone b  | `string` | `""` | Yes |
| alb\_security\_grp | Security Group id for Load Balancer | `string` | `""` | Yes |
| alb\_security\_grp\_1 | Additional Security Group id for Load Balancer  | `string` | `""` | Yes |
| ec2\_security\_grp | Security Group id for ec2 instance | `string` | `""` | Yes |
| ecs\_key\_pair\_name | Key pair for EC2 instances | `string` | `""` | Yes |
| image\_id | Provide the AMI ID  | `string` | `""` | Yes |
| instance\_type | EC2 Instance types | `string` | `""` | Yes |
| max\_instance\_size | Maximum no of EC2 instances in a Autoscale Group  | `string` | `""` | Yes |
| min\_instance\_size | Minimum no of EC2 instances in a Autoscale Group | `string` | `""` | Yes |
| desired\_capacity | Desired no of EC2 instances in a Autoscale Group | `string` | `""` | no |
| num\_of\_tasks | No of active containers requires  | `string` | `""` | Yes |
| container\_image | docker image name from ECR  | `string` | `""` | Yes |
| container\_port | container port (exposed port within dockerfile) | `string` | `""` | Yes |
| log\_group\_name | Log Group name where container logs stores | `string` | `"/aws/ecs"` | Yes |
| default\_tags | Default Tags | `list(map(string))` | `[]` | yes |

## Outputs
| Name | Description |
|------|-------------|
| ClusterName | ECS cluster name |
| BService | ECS Blue Deployment service name |
| GService | ECS Green Deployment service name |
| ElbName | Application Load Balancer Name |
| TaskName | Task Definition name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
