# main.tf

# Specify the provider
provider "aws" {
  region = var.region_name
}

# Data source to get the VPC
data "aws_vpc" "selected" {
  id = var.vpc_id
}

# Data source to get the route tables associated with the VPC
data "aws_route_tables" "selected" {
  vpc_id = var.vpc_id
}

# Data source to get the subnets associated with the VPC
data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# Security group for the EC2 VPC endpoint
resource "aws_security_group" "ec2_endpoint_sg" {
  name        = "ec2-endpoint-sg"
  description = "Security group for EC2 VPC Endpoint"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  # No egress rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the S3 VPC endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region_name}.s3"
  route_table_ids = [for rt in data.aws_route_tables.selected.ids : rt]
}

# Create the EC2 VPC endpoint
resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region_name}.ec2"
  vpc_endpoint_type = "Interface"
  subnet_ids        = data.aws_subnets.selected.ids
  security_group_ids = [aws_security_group.ec2_endpoint_sg.id]
}
