variable "enable_vpc" {
  default = "false"
  description = "Define Boolean value to enable or disable VPC"
}
variable "lambdaFunctionName" {
  description = "Defines the lambda function name"
}
variable "subnet_id" {
  description = "The subnet id of lambda"
  type = list(string)
}
variable "sg_id" {
  description = "The security group id of lambda"
  type = list(string)
}
variable "runtime" {
  description = "The runtime of the lambda to create"
  default     = "python3.7"
}
variable "handler" {
  description = "The handler name of the lambda (a function defined in your lambda)"
  default     = "handler"
}
variable "memory_size" {
  description = "The memory size of the lambda"
  default     = "1024"
}
variable "lambda_timeout" {
  description = "The lambda timeout"
  default     = "900"
}
variable "concurrency" {
  description = "Define the concurrency value"
  default     = "-1"
}
variable "log_retention" {
  description = "Define the log retention period"
  default     = "7"
}
variable "env_vars" {
  description = "Define the env vars for lambda function"
  type        = map(string)
  default     = {
    testing	= "true"
  }
}
variable "default_tags" {
  description = "Define the default tags"
  default     = []
}
#variable "create_lambda_layer" {
#  description = "Boolean value to create lambda layer"
# default     = "true"
#}

variable "create_event_invoke" {
  description = "Boolean value to create event invoke conditionally"
  default     = "false"
}
variable "maximum_event_age_in_seconds" {
  description = "Define the maximum event age in seconds"
  default     = []
}
variable "maximum_retry_attempts" {
  description = "Define the maximum retry attempts"
  default     = "2"
}
variable "role_arn" {
  description = "Define the role arn for lambda"
  default     = ""
}
