variable "region" {
  description = "aws region"
}
# variable "userDataDetails" {
# }
variable "NameTag" {
  description = "Describe the name tag ec2 of asg"
}
variable "Volume_NameTag" {
}
variable "BillingTag" {
  description = "Describe the billing tag for asg"
}
variable "OwnerTag" {
  description = "Describe the owner tag for asg"
}
variable "key_name" {
  description = "aws region"
}

variable "image_id" {
  description = "AMI id for ec2 instances"
}
variable "instance_type" {
  description = "ec2 instance size"
}
variable "device_name" {
  description = "EBS device name"
  default     = "/dev/xvda"
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
variable "EBS_volume_size" {
  default     = ""
  description = "The ebs volume size"
}
