terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.7.5"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc_endpoint" "endpoints" {
  for_each = { for vpc_id, service in var.service_endpoints : vpc_id => service }

  vpc_id              = each.key
  private_dns_enabled = true
  security_group_ids  = [var.sg_id]
  route_table_ids     = var.route_table_ids
  subnet_ids          = [var.subnet_id]  

  service_name       = each.value.service_name
  vpc_endpoint_type  = each.value.vpc_endpoint_type

  tags = {
    Name = "VPC Endpoint - ${each.key}"
  }
}



