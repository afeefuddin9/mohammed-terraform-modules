variable "env_prefix" {
  default = "LambdaBG"
  description = "project prefix for deploying lambda function"
}

variable "region" {
  default = "ap-southeast-2"
  description = "AWS region"
}
variable "default_tags" {
  type = map(string)
  description = "default tags"
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
  default = "mylambda"
  description = "github repo name"
}

variable "Branch" {
  default = "master"
  description = "github branch for source code"
}

variable "StageAliasName" {
  default     = "green"
  description = "alias pointing at staging lambda function version"
}

variable "ProdAliasName" {
  default     = "blue"
  description = "alias pointing at production lambda function version"
}


