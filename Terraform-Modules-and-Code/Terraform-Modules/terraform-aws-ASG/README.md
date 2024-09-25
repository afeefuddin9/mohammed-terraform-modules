# AWS Auto Scaling Group (ASG) Terraform module

Terraform module which creates Auto Scaling resources on AWS.

These types of resources are supported:

* [Launch Template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template)
* [Auto Scaling Group](https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html)

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
# Create autoscale group for app servers
module "autoscale_app" {
  source            = "github.com/sgs-dxc/tf-aws-ASG.git?ref=v1.3"
  BillingTag        = "DxInfra"
  NameTag           = "DxInfra-testing"
  Volume_NameTag = "DxInfra-testing"  
  OwnerTag          = "DX"
  # replace the values accordingly
  ec2_subnet_a      = module.VPC.web_subnet_a_id
  ec2_subnet_b      = module.VPC.web_subnet_b_id
  env_prefix        = local.env_prefix
  image_id          = "ami-0b1e534a4ff9019e0"
  instance_type     = "t3.medium"
  key_pair_name     = "key_name"
  asg_instance_profile_prefix= local.asg_instance_profile_prefix
  desired_capacity  = "1"  
  max_instance_size = "1"
  min_instance_size = "1"
  monitor           = true
  public_ip_address = false
  r_volume_size     = "30"
  region            = local.region
  # replace the values accordingly
  sec_grp           = [module.sg_alb.security_group_app, module.sg_alb.security_group_jump_servers1] 

# Please find the userdata in S3 bucket named "dxpf-infra-ops" and key "EC2-ASG-user-data"
userDataDetails = base64encode(templatefile("userdata_to_ec2.sh", { ssm_cloudwatch_config = aws_ssm_parameter.cw_agent.name }))  

  vpc_id            = module.VPC.vpc_id
  # Existing Target Group ARN (replace the values accordingly)
  target_grp_arn          = module.ALB-appServer.target_group_arns
  enable_asg_notification = true
  # replace the values accordingly
  sns_topic_arn           = module.sns-email-topic.arn
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

## Autoscaling group Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS Region where resources should be created  | `string` | `""` | Yes |
| env\_prefix | Creates a unique name beginning with the specified prefix | `string` | n/a | yes |
| max_instance_size | The maximum size of the auto scale group | `string` | n/a | yes |
| min_instance_size | The minimum size of the auto scale group | `string` | n/a | yes |
| desired_capacity | The number of Amazon EC2 instances that should be running in the group | `string` | n/a | yes |
| vpc_id | The vpc Id of the autoscaling group | `string` | n/a | yes |
| ec2_subnet_a | The subnet Id of the autoscaling group | `string` | n/a | yes |
| ec2_subnet_b | The subnet Id of the autoscaling group | `string` | n/a | yes |
| NameTag | The name tag of Autoscaling group| `string` | n/a | yes |
| BillingTag | The Billing tag of Autoscaling group | `string` | n/a | yes |
| OwnerTag | The Owner tag of Autoscaling group | `string` | n/a | yes |
| termination_policies | A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default | `list(string)` | ["Default"] | no |
| enabled\_metrics | A list of metrics to collect. The allowed values are GroupMinSize, GroupMaxSize, GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances | `list(string)` | <pre>[<br>  "GroupMinSize",<br>  "GroupMaxSize",<br>  "GroupDesiredCapacity",<br>  "GroupInServiceInstances",<br>  "GroupPendingInstances",<br>  "GroupStandbyInstances",<br>  "GroupTerminatingInstances",<br>  "GroupTotalInstances"<br>]</pre> | no |

## Launch Templates Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env\_prefix | Creates a unique name beginning with the specified prefix | `string` | n/a | yes |
| sec\_grp | The security group to be associate with the  | `string` | n/a | yes |
| iam\_instance\_profile | The IAM instance profile to associate with launched instances | `string` | n/a | yes |
| image\_id | The EC2 image ID to launch | `string` | n/a | yes |
| instance\_type | The size of instance to launch | `string` | n/a | yes |
| key\_pair\_name | The key name that should be used for the instance | `string` | n/a | yes |
| public\_ip\_address | The public id association to launch template | `boolean` | n/a | yes |
| monitor | The monitoring feature enabling | `boolean` | n/a | yes |
| zone | The zone name for the instance | `string` | n/a | yes |
| r\_volume\_type | The volume type of the root storage | `string` | n/a | yes | 
| r\_volume\_size | The volume size of the root storage | `string` | n/a | yes |
| ebs\_block\_device | Additional EBS block devices to attach to the instance | `list(map(string))` | `[]` | no |
| enable_asg_notification | Enable Autoscale Cloudwatch Notification | `boolean` | n/a | yes |
| sns_topic_arn | SNS Topic ARN | `string` | n/a | yes |
| target_grp_arn | ALB Target Group ARN | `string` | n/a | yes |

## Autoscaling group Outputs
| Name | Description |
|------|-------------|
| ASG | The ARN for this AutoScaling Group |

## Launch Template Outputs
| Name | Description |
|------|-------------|
| launch_template | The ID of the launch template |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
