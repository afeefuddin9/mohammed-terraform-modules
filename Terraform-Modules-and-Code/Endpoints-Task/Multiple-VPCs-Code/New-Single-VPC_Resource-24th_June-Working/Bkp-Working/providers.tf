terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.7.5"
}

#Region 1 for Oregon
provider "aws" {
  alias = "us_west_2"
  #region = "us-west-2"
  region = var.region_oregon
}


#Region 2 for Singapore
provider "aws" {
  alias = "ap_southeast_1"
  #region = "ap-southeast-1"
  region = var.region_singapore
}


# #Region 3 for Tokyo
# provider "aws" {
#   alias  = "ap_northeast_1"
#   #region = var.reg"ap-northeast-1"
#   region = var.region_tokyo
# }