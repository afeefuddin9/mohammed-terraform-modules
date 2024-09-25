variable "envPrefix" {
  description = "To define the env prefix"
   validation {
    condition     = length(var.envPrefix) > 0
    error_message = "envPrefix cannot be an empty string."
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
variable "region" {
  description = "Specify the region"
  type=string
  validation {
    condition= contains(["us-west-2", "ap-southeast-1","ap-northeast-1","us-east-1"], var.region)
    error_message="${var.region} region restricted from creating resources and allowed regions are 'us-west-2', 'ap-southeast-1','ap-northeast-1','us-east-1'"
  }
}
variable "default_tags" {
  type = map(string)
  validation {
    condition = alltrue([for tag in ["Project", "Billing", "Owner","Managed"] : contains(keys(var.default_tags),tag)])
    error_message = "Please include tags for Project, Billing, Owner and Managed."
    }
}
variable "display_name" {
  type        = string
  description = "Name shown in confirmation emails"
}
variable "email_addresses" {
  description = "Mention the email adressess for the topic"
  type        = list(string)
  validation {
    condition = alltrue([
      for email in var.email_addresses : can(regex("@sony.com$", email))
    ])
    error_message = "The given email address must be @sony.com"
  }
}

variable "protocol" {
  default     = "email"
  description = "SNS Protocol to use. email or email-json"
  type        = string
}

variable "stack_name" {
  type        = string
  description = "Unique Cloudformation stack name that wraps the SNS topic."
}

