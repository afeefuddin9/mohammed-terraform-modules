variable "region" {
  default = "ap-southeast-2"
  description = "AWS region"
}

variable "default_tags" {
  type = map(string)
  description = "default tags"
}

variable "env_prefix" {
  default = "ecs-bg"
  description = "prefix for ecs project"
}

variable "repository_uri" {
  default     = "768502287836.dkr.ecr.ap-southeast-2.amazonaws.com/dxinfra"
  description = "ecr image repo uri"
}

variable "OAuthToken" {
  default = "b858b711befbd931b12351301fcf5fc07c02c689"
  description = "github token to connect codepipeline to github"
}

variable "Owner" {
  default = "pradeep-sony"
  description = "github user"
}

variable "Repo" {
  default = "ecs-demo"
  description = "github repo name"
}

variable "Branch" {
  default = "master"
  description = "github branch for source code"
}

variable "ElbName" {
  default = "ALB-ECS-BG"
  description = "aws alb name"
}

variable "ClusterName" {
  default = "DxinfraApp"
  description = "ecs cluster name"
}

variable "TaskName" {
  default = "DxinfraApp"
  description = "task definition name"
}

variable "BService" {
  default = "ServiceA"
  description = "ecs cluster service"
}

variable "GService" {
  default = "ServiceB"
  description = "ecs cluster service"
}

