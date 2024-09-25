variable "create_ec2_metrics" {
    default     = "false"
  description = "Boolean values whether to create the alarm or not"
}
variable "EBS-Byte-Balance-ec2" {
  default     = "false"
  description = "Boolean values whether to create the alarm or not"
}
variable "create_lambda_metrics" {
  default     = "false"
  description = "Boolean values whether to create the alarm or not"
}
variable "create_asg_metrics" {
  default     = "false"
  description = "Boolean values whether to create the alarm or not"
}
variable "create_alb_metrics" {
  default     = "false"
  description = "Boolean values whether to create the alarm or not"
}
variable "EBS-Byte-Balance-asg" {
  default     = "false"
  description = "Boolean values whether to create the alarm or not"
}
variable "sns_topic_arn" {
  description = "The sns topic for the notification"
}
variable "sns_topic_arn2" {
  description = "The sns topics for notification and to trigger lambda function"
  default = []
}
variable "envPrefix" {
  description = "The envPrefix of the application"
}
variable "alb_arn" {
  description = "The arn of the alb to attach metric monitoring"
  default = ""
}
variable "target_group_arns" {
  description = "The arn of the target group to attach metric monitoring"
  default = ""
}
variable "asg_id" {
  description = "The autoscaling group id to attach metric monitoring"
  default = ""
}
variable "function_name" {
  description = "The function name of the lambda to attach metric monitoring"
  default     = ""
}
variable "ec2_instance_id" {
  description = "The id of the ec2 instance to attach metric monitoring"
  default     = ""
}
variable "ami_id" {
  description = "The id of the ec2 instance to attach metric monitoring"
  default     = ""
}
variable "path" {
  description = "The id of the ec2 instance to attach metric monitoring"
  default     = ""
}
variable "device" {
  description = "The id of the ec2 instance to attach metric monitoring"
  default     = ""
}
variable "fstype" {
  description = "The id of the ec2 instance to attach metric monitoring"
  default     = ""
}
variable "instance_type" {
  description = "The id of the ec2 instance to attach metric monitoring"
  default     = ""
}
variable "region" {
  description = "Define the region"
  default     = ""
}
variable "default_tags" {
  type        = map(string)
  description = "default tags"
  default     = {}
}
