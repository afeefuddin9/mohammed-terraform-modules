# Fetch all VPCs in the Oregon Region
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

#All my endpoints creation for VPC's

#s3 Endpoint
resource "aws_vpc_endpoint" "s3" {
  for_each            = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id              = each.value
  service_name        = "com.amazonaws.us-west-2.s3"
  vpc_endpoint_type   = "Gateway"
  route_table_ids     = [aws_route_table.private[each.value].id]
  tags = {
    Name = "VPC-Id-${each.key}-s3"
  }
}

#ec2 Endpoint
resource "aws_vpc_endpoint" "ec2" {
  for_each            = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id              = each.value
  service_name        = "com.amazonaws.us-west-2.ec2"
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  subnet_ids          = data.aws_subnets.private_subnets[each.value].ids
  security_group_ids  = [aws_security_group.endpoint[each.value].id]
  tags = {
    Name = "VPC-Id-${each.key}-ec2"
  }
}

#Lambda Endpoint
resource "aws_vpc_endpoint" "lambda" {
  for_each            = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id              = each.value
  service_name        = "com.amazonaws.us-west-2.lambda"
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  subnet_ids          = data.aws_subnets.private_subnets[each.value].ids
  security_group_ids  = [aws_security_group.endpoint[each.value].id]
  tags = {
    Name = "VPC-Id-${each.key}-lambda"
  }
}

#ECR Endpoint
resource "aws_vpc_endpoint" "ecr_dkr" {
  for_each            = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id              = each.value
  service_name        = "com.amazonaws.us-west-2.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  subnet_ids          = data.aws_subnets.private_subnets[each.value].ids
  security_group_ids  = [aws_security_group.endpoint[each.value].id]
  tags = {
    Name = "VPC-Id-${each.key}-ecr_dkr"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  for_each            = toset(data.aws_vpcs.all_vpcs.ids)
  vpc_id              = each.value
  service_name        = "com.amazonaws.us-west-2.ecr.api"
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  subnet_ids          = data.aws_subnets.private_subnets[each.value].ids
  security_group_ids  = [aws_security_group.endpoint[each.value].id]
  tags = {
    Name = "VPC-Id-${each.key}-ecr_api"
  }
}
