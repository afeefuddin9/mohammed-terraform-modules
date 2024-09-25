variable "env_prefix" {
  description = "project prefix for ecs environment"
  validation {
    condition     = length(var.env_prefix) > 3
    error_message = "envPrefix cannot be an empty string."
  }
}
variable "fargate_cpu" {
  description = "Required CPU for fargate"
}
variable "fargate_memory" {
  description = "Required Memory for fargate"
}
variable "log_group_name" {
  default     = "/aws/ecs"
  description = "Cloud Watch Log Group name"
}
variable "region" {
  description = "AWS region"
  type=string
  validation {
    condition= contains(["us-west-2", "ap-southeast-1","ap-northeast-1","us-east-1"], var.region)
    error_message="${var.region} region restricted from creating resources and allowed regions are 'us-west-2', 'ap-southeast-1','ap-northeast-1','us-east-1'"
  }
}
variable "container_port" {
  description = "container port number"
}
variable "container_image" {
  description = "container image uri"
}
variable "num_of_tasks" {
  description = "number of tasks for a service"
}
variable "default_tags" {
  type        = map(string)
  description = "default tags"
  validation {
    condition = alltrue([for tag in ["Project", "Billing", "Owner","Managed"] : contains(keys(var.default_tags),tag)])
    error_message = "Please include tags for Project, Billing, Owner and Managed."
    }
}
variable "prod_tags" {
  type        = map(string)
  default     = { "IsProduction" : "True" }
  description = "tag to identify prod env"
}

variable "log_retention_days" {
  default     = "30"
  description = "Cloud Watch Log Group retention days"
}
variable "vpc_id" {
  description = "VPC Id"
}
variable "subnet_ids" {
  description = "the subnet id's to be associated"
  type = list(string)
}
variable "security_groups_ids" {
 description = "the subnet id's to be associated"
 type = list(string)
}
variable "assign_public_ip" {
  description = "whether to assign the public IP or not"
  default     = true
}
variable "target_group_arn1" {
 description = "the target group arn for service 1"
}
variable "target_group_arn2" {
  default     = ""
}
variable "create_bluegreen" {
  description = "Boolean value whether to create bluegreen deployment or not"
  default = false
}
variable "container_definitions" {
}
variable "listener1" {
    default     = ""
    description = "Define the first listener from alb modules"
}
variable "listener2" {
    default     = ""
    description = "Define the second listener from alb modules"
}
variable "service_count_max" {
    description = "Define the maximum count of the serivice"
    default     = "5"
}
variable "service_count_min" {
    description = "Define the minimum count of the serivice"
    default     = "1"
}
variable "sns_topic_arn" {
  description = "SNS Topic ARN"
}
variable "enable_step_scaling_for_service2" {
    default     = false
}
