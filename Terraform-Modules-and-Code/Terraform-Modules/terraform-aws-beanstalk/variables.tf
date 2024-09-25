variable "region" {
  default = "ap-southeast-2"
  description = "AWS region"
}

variable "default_tags" {
  type = map(string)
  description = "default tags"
}

variable "vpc_id" {}

variable "instance_subnets" {
  type    = list(string)
  description = "vpc subnet for beanstalk ec2 instances"
}
/*
variable "state_bucket" {
  default = "768502287836-terraform-state-prod-ap-southeast-2"
}
*/
variable "appdescription" {
  default = "Bluegreen app deployed through TF"
  description = "beanstalk application description"
}

variable "env_prefix" {
  default = "beanstalk-bg"
  description = "beanstalk prefix for cname"
}

variable "stack_name" {
  default = "64bit Amazon Linux 2018.03 v2.9.6 running Python 3.6"
  description = "beanstalk platform"
}

variable "envdescription" {
  default = "Bluegreen Env deployed through TF"
  description = "environment description"
}

variable "prod_tags" {
  type        = map(string)
  default     = { "IsProduction" : "True" }
  description = "tag to identify prod env"
}

variable "stg_tags" {
  type        = map(string)
  default     = { "IsProduction" : "False" }
  description = "tag to identify stg env"
}

variable "ssl_port" {
  default = "443"
  description = "listener in application load balancer"
}

variable "cert_arn" {
  default = "arn:aws:iam::768502287836:server-certificate/selfsign-dxinfra-elastic-beanstalk-x509"
  description = "arn of the ssl certificate "
}
