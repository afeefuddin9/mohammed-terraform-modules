variable "envPrefix" {
  description = "To define the env prefix"
   validation {
    condition     = length(var.envPrefix) > 0
    error_message = "envPrefix cannot be an empty string."
  }
}
variable "region" {
  description = "Specify the region"
  type=string
  validation {
    condition= contains(["us-west-2", "ap-southeast-1","ap-northeast-1","us-east-1"], var.region)
    error_message="${var.region} region restricted from creating resources and allowed regions are 'us-west-2', 'ap-southeast-1','ap-northeast-1','us-east-1'"
  }
}
variable "Environment" {
  description = "Specify the Environment"
  type=string
  validation {
    condition= contains(["Prod","Pre-Prod","QA", "Dev","Stable","Test"], var.Environment)
    error_message="Provide a valid Environment like Prod,Pre-Prod,QA,Dev,Stable, or Test"
  }
}
variable "enable_userdata" {
  default = true
}
variable "userdata_parameter_name" {
  default = "ap-southeast-1-ec2-userdata"
}
variable "Infra_tags" {
  description = "define ec2 infra tags"
  type        = map(string)
  default = {
    automated-backup = "yes"
    "Patch Group" = "amazonlinux2"
  }
  validation {
    condition = alltrue([for tag in ["automated-backup", "Patch Group"] : contains(keys(var.Infra_tags),tag)])
    error_message = "Please include tags for automated-backup and Patch Group."
    }
}
variable "Schedule_tags" {
  type = map(string)
  default = {
    schedule-enabled = "dxpf-oregon-stop-at-9pm"
  }
}

variable "default_tags" {
  type = map(string)
  validation {
    condition = alltrue([for tag in ["Project", "Billing", "Owner","Managed"] : contains(keys(var.default_tags),tag)])
    error_message = "Please include tags for Project, Billing, Owner and Managed."
    }
}
variable "instance_type" {
  description = "define the instance type"
}
variable "subnet_id" {
  description = "define the subnet ID"
}
variable "EC2_security_grp" {
  type        = list(string)
  description = "define the security group ID"
}
variable "instance_profile_prefix" {
  description = "To define the instance profile prefix"
}
variable "ebs_block_device" {
  type        = any
  description = "define ebs block device"
  default     = ""
}
variable "ec2_key_pair_name" {
  description = "key pair name"
  default     = ""
}
variable "monitor" {
  description = "define monitoring"
}
variable "root_volume_type" {
  description = "define the volume type"
}
variable "root_volume_size" {
  description = "define the volume size"
}
variable "ami_id" {
  description = "the AMI id"
  type=string
  validation {
    condition= substr(var.ami_id,0,4)=="ami-"
    error_message="ami id should start with ami-"
  }
}
variable "associate_public_ip_address" {
  description = "public ip boolean"
}
variable "interval" {
  description = "evaluation periods for status check"
}
variable "status_check_period" {
  description = "defines the status check period"
}
variable "status_check_threshold" {
  description = "defines the threshold for status check"
}
variable "alarm_sns_topic_arn" {
  description = "defines the alarm topic for notifications"
}
variable "create_role_ec2" {
  default     = "true"
  description = "set a boolean value whether to create the IAM role or not"
}
variable "instance_profile_name" {
  default     = ""
  description = "Define the instance IAM role name"
}
variable "create_recovery_alarm" {
  default     = true
  description = "set a boolean value whether to enable the recovery alarm or not"
}
