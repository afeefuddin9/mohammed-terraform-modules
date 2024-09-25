terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.7.5"
}

# Configure the AWS provider
provider "aws" {
  region = "us-west-2" # Replace with your desired region
}

# Fetch all VPCs in the current region
data "aws_vpcs" "all_vpcs" {}

data "aws_vpc" "selected" {
  for_each = toset(data.aws_vpcs.all_vpcs.ids)
  id       = each.value
}

data "aws_subnets" "private_subnets" {
  for_each = toset(data.aws_vpcs.all_vpcs.ids)

  filter {
    name   = "vpc-id"
    values = [each.value]
  }

  filter {
    name   = "tag:Tier"
    values = ["Private"]
  }
}

#Fething vpc name
data aws_vpc vpc_names {
  for_each = { for vpc_id in data.aws_vpcs.all_vpcs.ids : vpc_id => vpc_id }
  id       = each.value
}

output vpc_info {
  value = {
     for id, vpc in data.aws_vpc.vpc_names : id => {
      name = lookup(vpc.tags, "Name", "Name not found"),
      id   = id
    }
  }
}
#Fething vpc name end here


resource "aws_security_group" "endpoint" {
  for_each    = toset(data.aws_vpcs.all_vpcs.ids)
  name        = "allow-endpoint-access"
  description = "Allow access to VPC endpoints"
  vpc_id      = each.value

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected[each.value].cidr_block]
  }
}

resource "aws_route_table" "private" {
  for_each = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id   = each.value
}

# Create endpoints for each VPC
resource "aws_vpc_endpoint" "lambda" {
  for_each            = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id              = each.value
  service_name        = "com.amazonaws.us-west-2.lambda"
  vpc_endpoint_type   = "Interface"
  #private_dns_enabled = true
  auto_accept = true
  subnet_ids          = data.aws_subnets.private_subnets[each.value].ids
  security_group_ids  = [aws_security_group.endpoint[each.value].id]
}

resource "aws_vpc_endpoint" "ec2" {
  for_each            = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id              = each.value
  service_name        = "com.amazonaws.us-west-2.ec2"
  vpc_endpoint_type   = "Interface"
  #private_dns_enabled = true
  auto_accept = true
  subnet_ids          = data.aws_subnets.private_subnets[each.value].ids
  security_group_ids  = [aws_security_group.endpoint[each.value].id]
}

resource "aws_vpc_endpoint" "s3" {
  for_each            = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id              = each.value
  service_name        = "com.amazonaws.us-west-2.s3"
  vpc_endpoint_type   = "Gateway"
  route_table_ids     = [aws_route_table.private[each.value].id]
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  for_each            = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id              = each.value
  service_name        = "com.amazonaws.us-west-2.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  #private_dns_enabled = true
  auto_accept = true
  subnet_ids          = data.aws_subnets.private_subnets[each.value].ids
  security_group_ids  = [aws_security_group.endpoint[each.value].id]
}

resource "aws_vpc_endpoint" "ecr_api" {
  for_each            = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id              = each.value
  service_name        = "com.amazonaws.us-west-2.ecr.api"
  vpc_endpoint_type   = "Interface"
  #private_dns_enabled = true
  auto_accept = true
  subnet_ids          = data.aws_subnets.private_subnets[each.value].ids
  security_group_ids  = [aws_security_group.endpoint[each.value].id]
}