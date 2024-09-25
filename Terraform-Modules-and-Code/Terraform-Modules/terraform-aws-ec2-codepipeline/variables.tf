variable "region" {
  type        = string
  description = "AWS region"
}

variable "env_prefix" {
  type        = string
  description = "Project prefix"
}

variable "deployment_config_name" {
  type        = string
  description = "deployment_config type for deploying to ec2 instances"
}

variable "deployment_option" {
  type        = string
  description = "to define loadbalancer requirement"
}

variable "deployment_type" {
  type        = string
  description = "defining deployment type"
}

variable "autoscaling_groups" {
  type        = list(string)
  description = "autoscaling group names"
}

variable "target_group" {
  type        = string
  description = "target group name"
}

variable "trigger_events" {
  type        = list(string)
  default     = ["DeploymentFailure", "DeploymentStop", "DeploymentRollback", "InstanceFailure"]
  description = "trigger events to notify via SNS"
}

variable "alarms" {
  type        = list(string)
  description = "cloudwatch alarm names"
}

variable "OAuthToken" {
  type        = string
  description = "github token to connect codepipeline to github"
}

variable "Owner" {
  type        = string
  description = "github user"
}

variable "Repo" {
  type        = string
  description = "github repo name"
}

variable "Branch" {
  type        = string
  description = "github branch for source code"
}

variable "codedeploy_role" {
  type        = string
  description = "codedeploy role"
}

variable "codepipeline_role" {
  type        = string
  description = "codepipeline role"
}

variable "codebuild_role" {
  type        = string
  description = "codebuild role"
}

variable "sns_topic_arn" {
  type        = string
  description = "sns topic arn"
}

variable "s3_bucket" {
  description = "s3 bucket for articact store"
}
variable "Stage_Deploy_isEnabled" {
  default = "true"
}
variable "Stage_build_isEnabled" {
  default = "false"
}
variable "create_codedeploy_app" {
  default = "true"
}
variable "create_codebuild_project" {
  default = "true"
}
variable "source_git_provider_version" {
  default = "1"
}
