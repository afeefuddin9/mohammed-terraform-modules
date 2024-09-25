variable "region" {
  description = "The AWS region to deploy the resources in."
  type        = string
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
