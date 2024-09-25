# AWS EC2 Terraform module

Terraform module which creates the EC2 on AWS.

These types of resources are supported:

* [EC2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2)

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
  region = "us-west-2"
  ignore_tags {
    keys = ["Usage", "Usage-tag-source", "Usage-tag-update-time"]
  }
}
locals {
  ######## Start of GLOBAL variables (Need to change every values as per the project requirements including the default tags) ########
  region = "us-west-2"

  # Define the application name along with environment ex: VxProd, DigibotQa
  Application_Name = "DxPlatform"
  Environment      = "Test"

  # Define the application stage ex: QA, testing, production
  envPrefix           = "${local.Application_Name}-${local.Environment}"
  alarm_sns_topic_arn = "arn:aws:sns:us-west-2:768502287836:Lakshmi_test:67d9ef4e-2029-485b-b0b9-785e0192335c"
  userdata_parameter_name = "${local.region}-ec2-userdata"
  default_tags = {
    Project     = "dxplatform"
    Managed     = "Terraform"
    Billing     = "dxplatform" # This tag should be set as project specific to better cost allocation
    Owner       = "dxplatform"
    Environment = "${local.Environment}"
    schedule-enabled = "dxpf-oregon-stop-at-9pm"
  }
  Infra_tags = {
    automated-backup = "yes"
    "Patch Group"    = "amazonlinux2"
  }
  Schedule_tags = {
    schedule-disable = "yes"
  }


  #EC2 Module
  ami_id                          = "ami-0c2d06d50ce30b442"
  ec2_instance_type               = "t2.micro"
  ec2_key_pair_name               = "test_key"
  associate_public_ip_address     = true
  monitor                         = true
  custom_userdata                 = true
  instance_profile_prefix         = "${local.envPrefix}-ec2-app"
  ec2_EBS_volume_size             = "8"
  ec2_root_volume_size            = "8"
  status_check_threshold          = "80"
  evaluation_periods_status_check = "1"
  status_check_period             = "300"
}
module "ec2" {
  source  = "app.terraform.io/dxc-dxpf/ec2/aws"
  version = "1.4.0"
  Environment      = local.Environment
  envPrefix        = local.envPrefix
  EC2_security_grp = ["sg-06015b5d023e71"]
  #If the userdata is not required then set the variable "enable_userdata" to false
  enable_userdata = true
  userdata_parameter_name = local.userdata_parameter_name
  region                      = local.region
  subnet_id                   = "subnet-0d6df06edff8d"
  ami_id                      = local.ami_id
  instance_type               = local.ec2_instance_type
  associate_public_ip_address = local.associate_public_ip_address
  #If not using cloudwatch module for alarms enable the create_recovery_alarm and monitor to true
  create_recovery_alarm   = true
  monitor                 = local.monitor
  instance_profile_prefix = local.instance_profile_prefix
  default_tags = merge(
    {
      "Name" = format("%s-ec2_app", local.envPrefix)
    },
    local.default_tags
  )
  Infra_tags = local.Infra_tags 
  # about the root volume
  root_volume_type       = "standard"
  root_volume_size       = local.ec2_root_volume_size
  status_check_threshold = local.status_check_threshold
  interval               = local.evaluation_periods_status_check
  status_check_period    = local.status_check_period
  alarm_sns_topic_arn    = local.alarm_sns_topic_arn

  #By default the IAM role with the SSM permissions will be attached to the ec2
  #If you do not want this behaviour, please set "create_role_ec2" to false and provide the existed IAM role name for this variable "instance_profile_name"
  #instance_profile_name = "AmazonSSMForEc2"
  #create_role_ec2 = false

  # about the ebs volume (set enabled to true or false as per requirement)
  ebs_block_device = [
    {
      device_name           = "/dev/xvda"
      volume_type           = "gp2"
      volume_size           = local.ec2_EBS_volume_size
      delete_on_termination = true
      encrypted             = true
      enabled               = true
    },
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
| terraform | ~> 0.13.5 |
| aws | ~> 3.5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.5.0 |

## ec2 Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| AMI\_id | The image ID to launch| `string` | n/a | yes |
| sec\_grp | The security group to be associate with the ec2 | `string` | n/a | yes |
| subnet_id | The subnet Id of the ec2 | `string` | n/a | yes |
| instance\_type | The size of instance to launch | `string` | n/a | yes |
| key\_pair\_name | The key name that should be used for the instance | `string` | n/a | yes |
| public\_ip\_address | The public id association value | `boolean` | n/a | yes |
| monitor | The monitoring feature enabling | `boolean` | n/a | yes |
| zone | The zone name for the instance | `string` | n/a | yes |
| set\_private\_ip | Defines a boolean value to set private ip | `boolean` | n/a | yes |
| private\_ip | Defines the private ip address | `string` | n/a | no |
| associate\_EIP | Set a boolean value whether to associate the EIP or not | `boolean` | n/a | yes |
| name\_tag\_EIP | Defines the name tag of EIP | `string` | n/a | no |
| default\_tags | Defines the recovered ec2 tags | `string` | n/a | yes |
| Infra\_tags | Defines the Infra ec2 tags | `string` | yes | yes |
| Environment | Defines the Environment of the ec2 | `string` | n/a | yes |
| ec2\_IAM\_profile | IAM Profile for ec2 | `string` | n/a | yes |
| ec2\_IAM\_role | Defines the IAM role name | `string` | n/a | yes |
| r\_volume\_type | The volume type of the root storage | `string` | n/a | yes | 
| r\_volume\_size | The volume size of the root storage | `string` | n/a | yes |
| ebs\_block\_device | Additional EBS block devices to attach to the instance | `list(map(string))` | `[]` | no |

## Ec2 module Outputs
| Name | Description |
|------|-------------|
| ec2\_instance |The ID of the EC2. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
