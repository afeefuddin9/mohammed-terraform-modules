#Adding variable for TF workspace
variable "region_oregon" {
  description = "This variable will fetch from terraform workspace"
  type        = string
}


variable "region_singapore" {
  description = "The AWS region for Singapore"
  type        = string
}

variable "vpc_id_singapore" {
  description = "The ID of the VPC in the Singapore region"
  type        = string
  default     = "vpc-0b0d7d0e4a67ed700"  # VPC ID for Singapore region
}
