variable "cluster_name" {
  description = "The cluster_name"
}
variable "BService" {
  description = "Service name"
}
variable "env_prefix" {
  description = "ECR Repository name"
}
variable "git_repository" {
  type        = map(string)
  description = "ecs task environment variables"
}
variable "repository_url" {
  description = "The url of the ECR repository"
}
variable "region" {
  description = "The region to use"
  default     = "ap-northeast-1"
}
variable "container_name" {
  description = "Container name"
}
variable "TaskName" {
  description = "TaskName json file"
}
variable "default_tags" {
  description = "Define the tags"
}
variable "source_git_provider_version" {
  default = "1"
}