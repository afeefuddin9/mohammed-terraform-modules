variable "envPrefix" {
  description = "To define the env prefix"
  validation {
    condition     = length(var.envPrefix) > 0
    error_message = "envPrefix cannot be an empty string."
  }
}
variable "region" {
  description = "the region name"
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
variable "bucket-name" {
  description = "the default tags"
}
variable "default_tags" {
  description = "default tags"
  validation {
    condition = alltrue([for tag in ["Project", "Billing", "Owner","Managed"] : contains(keys(var.default_tags),tag)])
    error_message = "Please include tags for Project, Billing, Owner and Managed."
  }
}
variable "enable_versions" {
  description = "Boolean value to set versioning"
}
variable "enable_versions_dest_bucket" {
  description = "Boolean value to set versioning"
  default = "false"
}
variable "enable_lifecycle" {
  description = "Boolean value to set lifecycle"
  default = "false"
}
variable "restrict_public" {
  description = "Boolean value to set the public access"
  default     = "true"
}
variable "dest_bucket_arn" {
  description = "The destination bucket name"
  default  = ""
}
variable "replication_role" {
  description = "Boolean value to enable replication"
  default  = "false"
}
variable "create_replication_bucket" {
  description = "The destination bucket name"
  default  = "false"
}
variable "replication-bucket-name" {
  description = "The destination bucket name"
  default  = ""
}
variable "enable_lifecycle_dest" {
  description = "The destination bucket name"
  default  = "false"
}
