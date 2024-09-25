variable "region" {
  description = "aws region"
}
variable "userDataDetails" {
}
variable "NameTag" {
  description = "Describe the name tag ec2 of asg"
}
variable "Volume_NameTag" {
}
variable "BillingTag" {
  description = "Describe the billing tag for asg"
}
variable "metrics_granularity" {
 description = "Define Asg metrics granularity"
 default= "1Minute"
} 
variable "health_check_type" {
  description = "Define Health check type of Asg"
  default= "EC2"
}
variable "health_check_grace_period" {
  description = "Define health check grace period of Asg"
  default= "300"
}
variable "OwnerTag" {
  description = "Describe the owner tag for asg"
}
/*variable "launch_config" {
  description = "launch configuration name"
}*/
variable "max_instance_size" {
  description = "max number of instances"
}
variable "min_instance_size" {
  description = "min number of instances"
}
variable "desired_capacity" {
  description = "desired capacity of instances"
}
/*variable "default_cooldown" {
  description = "defining cooldown period"
}*/
variable "env_prefix" {
  description = "environment prefix"
}
variable "ec2_subnet_a" {
  description = "public subnet one"
}
variable "ec2_subnet_b" {
  description = "public subnet two"
}
variable "vpc_id" {
  description = "defines vpc id"
}
variable "enabled_metrics" {
  description = "A list of metrics to collect. The allowed values are GroupMinSize, GroupMaxSize, GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances"
  type        = list(string)
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
}
variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default"
  type        = list(string)
  default     = ["Default"]
}
variable "image_id" {
  description = "AMI id for ec2 instances"
}
variable "instance_type" {
  description = "ec2 instance size"
}
variable "key_pair_name" {
  description = "Key Pair for EC2"
}
variable "asg_instance_profile_prefix" {
  description = "Define the asg instance profile prefix"
}
variable "public_ip_address" {
  description = "Public IP address for ec2 instance"
}
variable "sec_grp" {
  type        = list(string)
  description = "Security Group id for ec2 instance"
}
variable "monitor" {
  description = "enable the ec2 monitoring"
}
variable "device_name" {
  description = "EBS device name"
  default = "/dev/xvda"
}
variable "ebs_encrypted" {
  description = "EBS encryption enabled"
  type        = bool
  default     = true
}
variable "ebs_optimized" {
  description = "EBS optimized or not"
  type        = bool
  default     = false
}
variable "default_version_update" {
  description = "Update the Latest version as default"
  type        = bool
  default     = false
}
/*
variable "r_volume_type" {
  description = "ebs root volume type"
}
*/
variable "EBS_volume_size" {
  default     = ""
  description = "The ebs volume size"
}
/*variable "timezone" {
  description = "define the time zone for ec2 instances"
}*/
variable "enable_if_ssm_exists" {
  description = "ALB Target Group ARN"
  default     = false
}
variable "target_grp_arn" {
  description = "ALB Target Group ARN"
  default     = "[]"
}
variable "enable_monitoring" {
  description = "Enable Autoscale Group Monitoring"
  type        = bool
  default     = false
}
variable "enable_asg_notification" {
  description = "Enable Autoscale Cloudwatch Notification"
  type        = bool
  default     = false
}
variable "sns_topic_arn" {
  description = "SNS Topic ARN"
}
