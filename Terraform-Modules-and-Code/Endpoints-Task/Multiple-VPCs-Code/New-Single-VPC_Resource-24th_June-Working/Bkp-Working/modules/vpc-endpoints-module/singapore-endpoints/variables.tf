terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

variable "region" {
  description = "The AWS region to deploy the resources in."
  type        = string
}


# variable "vpc_id" {
#   description = "The ID of the VPC for which to create the endpoints."
#   type        = string
# }
 

 
variable "vpc_ids_singapore" {
  description = "The IDs of the VPCs for which to create the endpoints."
  type        = list(string)
}
