variable "region" {
  description = "AWS region"
  type=string
  validation {
    condition= contains(["us-west-2", "ap-southeast-1","ap-northeast-1","us-east-1"], var.region)
    error_message="${var.region} region restricted from creating resources and allowed regions are 'us-west-2', 'ap-southeast-1','ap-northeast-1','us-east-1'"
  }
}
variable "default_tags" {
  type        = map(string)
  description = "default tags"
  validation {
    condition = alltrue([for tag in ["Project", "Billing", "Owner","Managed"] : contains(keys(var.default_tags),tag)])
    error_message = "Please include tags for Project, Billing, Owner and Managed."
    }
}
variable "vpc_id" {}
variable "listener1" {
}
variable "alb_target_group1" {
  default = ""
}
variable "volume_name" {
default     = ""
}
variable "volume" {
  description = "Used for a dynamic volume block for ECS service."
  type        = any
  default     = []
}
variable "efs_host_path" {
  default     = ""
}
/*
variable "alb_subnet1" {
  description = "Load Balancer Subnet ID"
}

variable "alb_subnet2" {
  description = "Load Balancer Subnet ID"
}
variable "alb_access_log_bucket" {
  description = "S3 Bucket name for Load Balancer Access Logs"
}

variable "alb_access_log_enable" {
  description = "Enable Load Balancer Access Logs"
  type        = bool
  default     = false
}
variable "alb_subnet1_cidr" {
  description = "Subnet CIDR of ALB"
}

variable "alb_subnet2_cidr" {
  description = "Subnet CIDR of ALB"
}
variable "target_group1_port" {
  default     = "80"
  description = "target group port number"
}

variable "target_group2_port" {
  default     = "8080"
  description = "target group port number"
}

variable "prod_tags" {
  type        = map(string)
  default     = { "IsProduction" : "True" }
  description = "tag to identify prod env"
}


variable "prod_lstn_port" {
  default     = "80"
  description = "production listener port number"
}

variable "stg_lstn_port" {
  default     = "8080"
  description = "staging listener port number"
}

variable "alb_security_grp" {
  description = "Security Group ID for Load Balancer"
}

variable "alb_security_grp_1" {
  description = "Security Group ID for Load Balancer"
}

variable "ec2_security_grp" {
  description = "Security Group ID for ECS instances"
}

variable "alb_ssl_policy" {
  default     = "ELBSecurityPolicy-2016-08"
  description = "Security Policy of the ALB"
}

variable "alb_certificate_arn" {
  description = "Certificate ARN for Application Load Balancer"
}

variable "ecs_key_pair_name" {
  description = "keys for ECS EC2 instances"
}

variable "image_id" {
  description = "image-id for launching EC2 instances"
}

variable "instance_type" {
  description = "EC2 instance type"
}

variable "max_instance_size" {
  description = "autoscaling group max num of EC2 instances"
}

variable "min_instance_size" {
  description = "autoscaling group min num of EC2 instances"
}

variable "desired_capacity" {
  description = "autoscaling group desired capacity"
}
*/

variable "ecs_subnet1" {
  description = "Subnet ID for Ec2 instances"
}

variable "ecs_subnet2" {
  description = "Subnet ID for Ec2 instances"
}

variable "env_prefix" {
  description = "project prefix for ecs environment"
  validation {
    condition     = length(var.env_prefix) > 3
    error_message = "envPrefix cannot be an empty string."
  }
}
variable "env_prefix_service2" {
  description = "project prefix for ecs environment"
 default = ""
}

variable "num_of_tasks" {
  description = "number of tasks for a service"
}
variable "iam_role" {
  default = ""
}
variable "container_port" {
  description = "container port number"
}
variable "log_retention_days" {
  default     = "30"
  description = "Cloud Watch Log Group retention days"
}

variable "log_group_name" {
  default     = "/aws/ecs"
  description = "Cloud Watch Log Group name"
}
variable "prod_tags" {
  type        = map(string)
  default     = { "IsProduction" : "True" }
  description = "tag to identify prod env"
}
variable "enable_ecs_service2" {
  default     = false
  description = "container image uri"
}
variable "listener2" {
  default = ""
}
variable "alb_target_group2" {
  default = ""
}
variable "stg_tags" {
  type        = map(string)
  default     = { "IsProduction" : "False" }
  description = "tag to identify stg env"
}
variable "container_definitions" {
  description = "Container definitions provided as valid JSON document. Default uses golang:alpine running a simple hello world."
  default     = ""
  type        = string
}
variable "container_definitions_service2" {
  description = "Container definitions provided as valid JSON document. Default uses golang:alpine running a simple hello world."
  default     = ""
  type        = string
}
variable "enable_ecs_task_definition2" {
  default     = false
  description = "enable ecs task definition2"
}
variable "task_role_arn" {
  default = ""
}
variable "iam_role_service2" {
  default = ""
}
variable "container_port_service2" {
  default = ""
}
