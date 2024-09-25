# Fetch all VPCs in the current region
data "aws_vpcs" "all_vpcs" {}

# Transform the list of VPC IDs into a map where each ID is paired with itself
locals {
  vpc_ids_map = { for vpc_id in data.aws_vpcs.all_vpcs.ids : vpc_id => vpc_id }
}

# Create aws_vpc data sources for each VPC
data "aws_vpc" "selected" {
  for_each = local.vpc_ids_map

  id = each.value
}

resource "aws_security_group" "endpoint" {
  for_each    = data.aws_vpc.selected

  name        = "allow-endpoint-access"
  description = "Allow access to VPC endpoints"
  vpc_id      = each.value.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [each.value.cidr_block]
  }
}

resource "aws_route_table" "private" {
  for_each = data.aws_vpc.selected

  vpc_id   = each.value.id
}

# Create endpoints for each VPC
resource "aws_vpc_endpoint" "lambda" {
  for_each            = { for k, v in data.aws_vpc.selected : k => v if contains(keys(v.tags), "Name") }

  vpc_id              = each.value.id
  service_name        = "com.amazonaws.us-west-2.lambda"
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  subnet_ids          = data.aws_vpcs.all_vpcs[each.key].subnets
  security_group_ids  = [aws_security_group.endpoint[each.key].id]
  tags = {
    Name = "${each.value.tags["Name"]}-lambda"
  }
}

resource "aws_vpc_endpoint" "ec2" {
  for_each            = { for k, v in data.aws_vpc.selected : k => v if contains(keys(v.tags), "Name") }

  vpc_id              = each.value.id
  service_name        = "com.amazonaws.us-west-2.ec2"
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  subnet_ids          = data.aws_vpcs.all_vpcs[each.key].subnets
  security_group_ids  = [aws_security_group.endpoint[each.key].id]
  tags = {
    Name = "${each.value.tags["Name"]}-ec2"
  }
}

resource "aws_vpc_endpoint" "s3" {
  for_each            = { for k, v in data.aws_vpc.selected : k => v if contains(keys(v.tags), "Name") }

  vpc_id              = each.value.id
  service_name        = "com.amazonaws.us-west-2.s3"
  vpc_endpoint_type   = "Gateway"
  route_table_ids     = [aws_route_table.private[each.key].id]
  tags = {
    Name = "${each.value.tags["Name"]}-s3"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  for_each            = { for k, v in data.aws_vpc.selected : k => v if contains(keys(v.tags), "Name") }

  vpc_id              = each.value.id
  service_name        = "com.amazonaws.us-west-2.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  subnet_ids          = data.aws_vpcs.all_vpcs[each.key].subnets
  security_group_ids  = [aws_security_group.endpoint[each.key].id]
  tags = {
    Name = "${each.value.tags["Name"]}-ecr-dkr"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  for_each            = { for k, v in data.aws_vpc.selected : k => v if contains(keys(v.tags), "Name") }

  vpc_id              = each.value.id
  service_name        = "com.amazonaws.us-west-2.ecr.api"
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  subnet_ids          = data.aws_vpcs.all_vpcs[each.key].subnets
  security_group_ids  = [aws_security_group.endpoint[each.key].id]
  tags = {
    Name = "${each.value.tags["Name"]}-ecr-api"
  }
}
