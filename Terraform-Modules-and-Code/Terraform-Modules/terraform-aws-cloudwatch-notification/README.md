# tf-aws-cloudwatch-notification
A terraform module for the Cloud watch Notifications and Alerts
These types of resources are supported:

* [Cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch)

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
    keys =  ["Usage"]
  }
}
locals {
  default_tags = {
    Project = "Dx"
    Managed = "Terraform"
    Owner   = "Dx"
    Billing = "Dx" # This tag should be set as project specific to better cost allocation
  }
  env_prefix        = "testing-VPC"
  region = "ap-southeast-2"
}
# Create cloudwatch alarms and Email Notification
module "cloudwatch" {
  source        = "github.com/sgs-dxc/tf-aws-cloudwatch-notification.git"
  region        = local.region
  sns_topic_arn = module.sns-email-topic.arn
  target_group_arns = module.ALB.target_group_arns
  alb_arn           = module.ALB.alb_arn
  asg_id            = module.autoscale_app.ASG
  envPrefix         = local.envPrefix
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

## Cloudwatch Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env\_prefix | Creates a unique name beginning with the specified prefix | `string` | n/a | yes |
| create_ec2_metrics | Boolean values whether to create the alarm or not | `string` | false | yes |
| create_lambda_metrics | Boolean values whether to create the alarm or not | `string` | false | yes |
| create_asg_metrics | Boolean values whether to create the alarm or not | `string` | true | yes |
| create_alb_metrics| Boolean values whether to create the alarm or not | `string` | true | yes |
| sns_topic_arn | The sns topic of the alb and asg notification | `string` | n/a | yes |
| envPrefix | The envPrefix of the application | `string` | n/a | yes |
| alb_arn | The alb arn to create the alarm | `string` | n/a | yes |
| target_group_arns | The target group arn to create the alarm | `string` | n/a | yes |
| asg_id | The autoscaling group ID to create the alarm | `string` | n/a | yes |
| function_name | The function name to create the alarm | `string` | n/a | yes |
| ec2_instance_id | The ec2 instance ID to create the alarm | `string` | n/a | yes |
| region | The region of the application | `string` | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
