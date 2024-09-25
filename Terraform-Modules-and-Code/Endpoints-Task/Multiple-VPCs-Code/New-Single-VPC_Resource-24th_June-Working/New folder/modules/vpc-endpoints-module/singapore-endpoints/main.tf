data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_route_tables" "existing" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "tag:Tier"
    values = ["Private"]
  }
}

resource "aws_security_group" "endpoint" {
  name        = "allow-endpoint-access"
  description = "Allow access to VPC endpoints"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type   = "Gateway"
  route_table_ids     = [for rt in data.aws_route_tables.existing.ids : rt]

  tags = {
    Name = "VPC-Id-${var.vpc_id}-s3"
  }
}

resource "aws_vpc_endpoint" "lambda" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.lambda"
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  private_dns_enabled = true
  subnet_ids          = data.aws_subnets.private_subnets.ids
  security_group_ids  = [aws_security_group.endpoint.id]

  tags = {
    Name = "VPC-Id-${var.vpc_id}-lambda"
  }
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  private_dns_enabled = true
  subnet_ids          = data.aws_subnets.private_subnets.ids
  security_group_ids  = [aws_security_group.endpoint.id]

  tags = {
    Name = "VPC-Id-${var.vpc_id}-ec2"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  private_dns_enabled = true
  subnet_ids          = data.aws_subnets.private_subnets.ids
  security_group_ids  = [aws_security_group.endpoint.id]

  tags = {
    Name = "VPC-Id-${var.vpc_id}-ecr_dkr"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  private_dns_enabled = true
  subnet_ids          = data.aws_subnets.private_subnets.ids
  security_group_ids  = [aws_security_group.endpoint.id]

  tags = {
    Name = "VPC-Id-${var.vpc_id}-ecr_api"
  }
}
