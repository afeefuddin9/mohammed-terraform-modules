provider "aws" {
  region = "ap-southeast-1"
}

/*
terraform {
  backend "s3" {
    bucket = "tfstate-dx-platform-portal"
    key    = "terraform.tfstate"
    region = "ap-southeast-1"
  }
  required_providers {
    aws = {
      version = "3.30.0"
    }
  }
}
*/

# Set the Terraform Cloud configuration.
terraform {
  cloud {
    organization = "dxc-dxpf"
    workspaces {
      name = "tf-aws-dxplatform-portal"
    }
  }
}
