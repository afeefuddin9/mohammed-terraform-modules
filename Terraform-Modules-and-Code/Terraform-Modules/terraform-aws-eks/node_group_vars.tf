variable "ng_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  type        = string
  default     = "node-group"
}

variable "autoscaling_groups" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = []
}
variable "desired_size" {
  description = "desired capacity of instances"
  default     = 1
}
variable "min_size" {
  description = "desired capacity of instances"
  default     = 1
}
variable "max_size" {
  description = "desired capacity of instances"
  default     = 2
}
variable "ng_subnets" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = []
}
