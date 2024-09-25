provider "aws" {
  alias  = "ap_southeast_1"
  region = var.region
}

data "aws_vpc" "selected" {
  provider = aws.ap_southeast_1
  #id = var.vpc_id #Commenting old veriable
  #id = vpc_ids_singapore #Commenting old veriable
  for_each = toset(var.vpc_ids_singapore)
  id       = each.key #Adding vpc dynamically
}

data "aws_route_tables" "existing" {
  for_each = toset(var.vpc_ids_singapore)
  provider = aws.ap_southeast_1
  filter {
    name   = "vpc-id"
    #values = [var.vpc_id]#Commenting old veriable
    #values = toset[var.vpc_ids_singapore] #Commenting old veriable
    values = [each.key] #Adding vpc dynamically
  }
}


# ************Define local values to select one subnet per availability zone************
 
data "aws_subnets" "private_subnets" {
  for_each = toset(var.vpc_ids_singapore)
  provider = aws.ap_southeast_1
  filter {
    name   = "vpc-id"
    values = [each.key]
  }
  filter {
    name   = "tag:Tier"
    values = ["Private"]
  }
}

locals {
  # Map of AZ to subnet IDs
  az_to_subnet_ids = {
    for vpc_id, subnets in data.aws_subnets.private_subnets :
    vpc_id => {
      for az in distinct([
        for subnet_id in subnets.ids : 
        data.aws_subnet.subnet[subnet_id].availability_zone
      ]) :
      az => [
        for subnet_id in subnets.ids : subnet_id
        if data.aws_subnet.subnet[subnet_id].availability_zone == az
      ][0]  # Pick the first subnet in each AZ
    }
  }
}

data "aws_subnet" "subnet" {
  for_each = toset(flatten([for vpc_id, subnets in data.aws_subnets.private_subnets : subnets.ids]))
  id = each.key
}
 
# ************Define the data source to get subnets for each VPC End here************



#This is 2st Draft to testing
# resource "aws_security_group_rule" "endpoint" {
#   for_each = toset(var.vpc_ids_singapore)
#   provider    = aws.ap_southeast_1
#   name        = "allow-endpoint-access"
#   description = "Allow access to VPC endpoints"
#   vpc_id      = var.vpc_ids_singapore

#    ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = [data.aws_vpc.selected.cidr_block]
#   }
# }


#This is 2st Draft to testing
# resource "aws_security_group" "endpoint" {
#   for_each    = toset(var.vpc_ids_singapore)
#   name        = "example-sg-${each.key}"
#   description = "Allow access to VPC endpoints ${each.key}"
#   vpc_id      = each.key

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     #cidr_blocks = [data.aws_vpc.selected.cidr_block]  #Commenting old cidr
#     cidr_blocks = [data.aws_vpc.selected[each.key].cidr_block]
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     #cidr_blocks = [data.aws_vpc.selected.cidr_block]   #Commenting old cidr
#     cidr_blocks = [data.aws_vpc.selected[each.key].cidr_block]
#   }

#   tags = {
#     Name = "example-sg-${each.key}"
#   }
# }
# ##This is 2st Draft to testing block end



#Adding SG as Rule as Indevidual 
resource "aws_security_group" "endpoint" {
  for_each    = toset(var.vpc_ids_singapore)
  name        = "singapore-endpoint-sg-${each.key}"
  description = "Allow access to VPC endpoints ${each.key}"
  vpc_id      = each.key
}

resource "aws_security_group_rule" "http_rule" {
  for_each              = toset(var.vpc_ids_singapore)
  type                  = "ingress"
  from_port             = 80
  to_port               = 80
  protocol              = "tcp"
  cidr_blocks           = [data.aws_vpc.selected[each.key].cidr_block]
  security_group_id     = aws_security_group.endpoint[each.key].id
}

resource "aws_security_group_rule" "https_rule" {
  for_each              = toset(var.vpc_ids_singapore)
  type                  = "ingress"
  from_port             = 443
  to_port               = 443
  protocol              = "tcp"
  cidr_blocks           = [data.aws_vpc.selected[each.key].cidr_block]
  security_group_id     = aws_security_group.endpoint[each.key].id
}
#Adding SG as Rule as Indevidual End here


resource "aws_vpc_endpoint" "s3" {
  provider           = aws.ap_southeast_1
  for_each           = toset(var.vpc_ids_singapore) #Adding dynamic vpc ids
  vpc_id             = each.key  #Setting dynamic vpc ids
  service_name       = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type  = "Gateway"
  route_table_ids    = data.aws_route_tables.existing[each.key].ids

  tags = {
    Name = "VPC-Id-${each.key}-s3" #Adding new one
  }
}

resource "aws_vpc_endpoint" "lambda" {
  provider           = aws.ap_southeast_1
  for_each    = toset(var.vpc_ids_singapore) #Adding dynamic vpc ids
  vpc_id      = each.key  #Setting dynamic vpc ids
  service_name       = "com.amazonaws.${var.region}.lambda"
  vpc_endpoint_type  = "Interface"
  auto_accept        = true
  private_dns_enabled = true
  subnet_ids         = [for az in keys(local.az_to_subnet_ids[each.key]) : local.az_to_subnet_ids[each.key][az]]
  security_group_ids = [aws_security_group.endpoint[each.key].id]

  tags = {
    Name = "VPC-Id-${each.key}-lambda" #Adding new one
  }
}

resource "aws_vpc_endpoint" "ec2" {
  provider           = aws.ap_southeast_1
  for_each    = toset(var.vpc_ids_singapore) #Adding dynamic vpc ids
  vpc_id      = each.key  #Setting dynamic vpc ids
  service_name       = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type  = "Interface"
  auto_accept        = true
  private_dns_enabled = true
  subnet_ids         = [for az in keys(local.az_to_subnet_ids[each.key]) : local.az_to_subnet_ids[each.key][az]] #adding this to attach one subnet from all AZ's
  security_group_ids = [aws_security_group.endpoint[each.key].id]


  tags = {
    Name = "VPC-Id-${each.key}-ec2" #Adding new one
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  provider           = aws.ap_southeast_1
  for_each    = toset(var.vpc_ids_singapore) #Adding dynamic vpc ids
  vpc_id      = each.key  #Setting dynamic vpc ids
  service_name       = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type  = "Interface"
  auto_accept        = true
  private_dns_enabled = true
  subnet_ids         = [for az in keys(local.az_to_subnet_ids[each.key]) : local.az_to_subnet_ids[each.key][az]]
  security_group_ids = [aws_security_group.endpoint[each.key].id]

  tags = {
    Name = "VPC-Id-${each.key}-ecr_drk" #Adding new one
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  provider           = aws.ap_southeast_1
  for_each    = toset(var.vpc_ids_singapore) #Adding dynamic vpc ids
  vpc_id      = each.key  #Setting dynamic vpc ids
  service_name       = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type  = "Interface"
  auto_accept        = true
  private_dns_enabled = true
  subnet_ids         = [for az in keys(local.az_to_subnet_ids[each.key]) : local.az_to_subnet_ids[each.key][az]]
  security_group_ids = [aws_security_group.endpoint[each.key].id]

  tags = {
    Name = "VPC-Id-${each.key}-ecr_api" #Adding new one
  }
}