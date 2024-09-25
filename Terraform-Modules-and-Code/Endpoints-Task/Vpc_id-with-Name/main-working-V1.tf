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

# Create resources for each VPC
resource "aws_subnet" "private_1" {
  for_each          = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id            = each.value
  cidr_block        = cidrsubnet(data.aws_vpc.selected[each.key].cidr_block, 8, 1)
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "private_2" {
  for_each          = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id            = each.value
  cidr_block        = cidrsubnet(data.aws_vpc.selected[each.key].cidr_block, 8, 2)
  availability_zone = "us-west-2b"
}

data "aws_vpc" "selected" {
  for_each = toset(data.aws_vpcs.all_vpcs.ids)
  id       = each.value
}

resource "aws_security_group" "endpoint" {
  for_each    = toset(data.aws_vpcs.all_vpcs.ids)
  name        = "allow-endpoint-access"
  description = "Allow access to VPC endpoints"
  vpc_id      = each.value

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected[each.key].cidr_block]
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
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.private_1[each.key].id, aws_subnet.private_2[each.key].id]
  security_group_ids  = [aws_security_group.endpoint[each.key].id]
}

resource "aws_vpc_endpoint" "ec2" {
  for_each            = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id              = each.value
  service_name        = "com.amazonaws.us-west-2.ec2"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.private_1[each.key].id, aws_subnet.private_2[each.key].id]
  security_group_ids  = [aws_security_group.endpoint[each.key].id]
}

resource "aws_vpc_endpoint" "s3" {
  for_each            = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id              = each.value
  service_name        = "com.amazonaws.us-west-2.s3"
  vpc_endpoint_type   = "Gateway"
  route_table_ids     = [aws_route_table.private[each.key].id]
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  for_each            = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id              = each.value
  service_name        = "com.amazonaws.us-west-2.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.private_1[each.key].id, aws_subnet.private_2[each.key].id]
  security_group_ids  = [aws_security_group.endpoint[each.key].id]
}

resource "aws_vpc_endpoint" "ecr_api" {
  for_each            = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id              = each.value
  service_name        = "com.amazonaws.us-west-2.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.private_1[each.key].id, aws_subnet.private_2[each.key].id]
  security_group_ids  = [aws_security_group.endpoint[each.key].id]
}