variable "region" {
  description = "Name of the region"
  type=string
  validation {
    condition= contains(["us-west-2", "ap-southeast-1","ap-northeast-1","us-east-1"], var.region)
    error_message="${var.region} region restricted from creating resources and allowed regions are 'us-west-2', 'ap-southeast-1','ap-northeast-1','us-east-1'"
  }
}
variable "envPrefix" {
  description = "Name Tag for the Ec2 Instance"
  validation {
    condition     = length(var.envPrefix) > 3
    error_message = "envPrefix length not matching"
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
variable "default_tags" {
  type        = map(string)
  description = "default tags"
  validation {
    condition = alltrue([for tag in ["Project", "Billing", "Owner","Managed"] : contains(keys(var.default_tags),tag)])
    error_message = "Please include tags for Project, Billing, Owner and Managed."
    }
}
variable "s3_bucket" {
  description = "Id of s3 bucket"
  default     = ""
}
variable "s3_bucket_prefix" {
  description = "Id of s3 bucket"
  default     = ""
}
variable "production_evn" {
  description = "Name of the environment or stage"
  default     = false
}
variable "vpc_id" {
  description = "VPC ID"
}
variable "alb_subnet1" {
  description = "Load Balancer Subnet ID"
}
variable "alb_subnet2" {
  description = "Load Balancer Subnet ID"
}
variable "cookie_duration" {
  description = "Define the cookie duration"
  default     = 1800
}
variable "enable_stickiness" {
  default     = false
  description = "Boolean value to enable or disable stickiness"
}
variable "certificate_arn" {
  default = ""
}
variable "internal" {
  description = "Load Balancer internal or not"
  default     = "false"
}
variable "target_group_port" {
  default     = "8080"
  description = "target group port number"
}
variable "target_group_protocol" {
  default     = "HTTP"
  description = "target group protocol"
}
variable "prod_lstn_port" {
  default     = "443"
  description = "production listener port number"
}
variable "alb_security_grp" {
  type        = list(string)
  description = "Security Group ID for Load Balancer"
}
variable "healthy_threshold" {
  default     = "5"
  description = "Define the health check threshold"
}
variable "unhealthy_threshold" {
  default     = "2"
  description = "Define the unhealth check threshold"
}
variable "healthcheck_timeout" {
  default     = "5"
  description = "Define the health check timeout"
}
variable "healthcheck_interval" {
  default     = "10"
  description = "Define the health check interval"
}
variable "health_check_path" {
  default     = "/"
  description = "Define the health check interval"
}
variable "alb_ssl_policy" {
  default     = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  description = "Security Policy of the ALB"
}
variable "authorization_endpoint" {
  description = "the authorization endpoint"
  default     = ""
}
variable "create_listener_with_auth" {
  description = "enable https listener with authorization"
  default     = false
}
variable "create_listener_without_auth" {
  description = "enable https listener without authorization"
  default     = true
}
variable "create_auth_listener_rule" {
  description = "enable listener rule with authorization"
  default     = true
}
variable "client_id" {
  description = "The client id"
  default     = ""
}
variable "client_secret" {
  description = "The client secret"
  default     = ""
}
variable "issuer" {
  description = "The issuer"
  default     = ""
}
variable "token_endpoint" {
  description = "The the token endpoint"
  default     = ""
}
variable "user_info_endpoint" {
  description = "The user info endpoint"
  default     = ""
}
variable "path_values" {
  description = "the path value of the listener rule"
  default     = "[]"
}
variable "http_health_check_matcher" {
  description = "Set HTTP health check matcher"
  default     = 200 #Matcher aka success code. Range-example: 200-299
}
variable "create_listener_rule_without_auth" {
  description = "Boolean value whether to create the path based resource or not"
  default     = "false"
}
variable "sns_topic_arn" {
  description = "SNS Topic ARN"
}
variable "register_ec2_TG" {
  description = "Boolean value whether to register the ec2 with TG"
  default     = false
}
variable "ec2_instance_id" {
  description = "ec2 instance ID of registering ec2"
  default     = ""
}
variable "ec2_instance_port" {
  description = "ec2 instance port of registering ec2"
  default     = ""
}
variable "enable_second_target_group" {
  default = "false"
}
variable "create_listener_rule_without_auth_for_TG2" {
  default = "false"
}
variable "create_listener_with_auth_for_TG2" {
  default = "false"
}
variable "target_type" {
  default = "instance"
}
variable "enable_deletion_protection" {
  default = "true"
}
