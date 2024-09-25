variable "region" {
  default = "ap-southeast-2"
  description = "AWS region"
}

variable "default_tags" {
  type = map(string)
  description = "default tags"
}

variable "env_prefix" {
  default = "beanstalk-bg"
  description = "beanstalk prefix for cname"
}

variable "app" {
  default = "POC-BlueGreenDeloyment"
  description = "beanstalk application cname"
}

variable "env_1" {
  default = "PocBluegreen-Env2"
  description = "beanstalk environment name"
}

variable "env_2" {
  default = "PocBluegreen-Env2"
  description = "beanstalk environment name"
}


variable "OAuthToken" {
  default = "b858b711befbd931b12351301fcf5fc07c02c689"
  description = "github token to connect codepipeline to github"
}

variable "Owner" {
  default = "sgs-dxc"
  description = "github user"
}

variable "Repo" {
  default = "poc_bluegreendeploy"
  description = "github repo name"
}

variable "Branch" {
  default = "master"
  description = "github branch for source code"
}
