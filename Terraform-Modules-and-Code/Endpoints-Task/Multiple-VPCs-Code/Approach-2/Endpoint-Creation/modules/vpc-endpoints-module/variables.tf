# variables.tf

variable "region" {
  description = "The AWS region to deploy the resources in."
  type        = string
}

provider "aws" {
  region = var.region
}
