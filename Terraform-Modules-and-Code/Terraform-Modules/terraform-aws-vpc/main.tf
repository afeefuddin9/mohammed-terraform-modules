# Query all avilable Availibility Zone
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

# create a new VPC with the provided cidr range
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  #enable_classiclink               = var.enable_classiclink
  #enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  #assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = merge(
    {
      "Name" = format("%s-VPC", var.envPrefix)
    },
    var.default_tags,
    # var.vpc_tags,
  )
}

# attatch an internet gateway to this VPC
resource "aws_internet_gateway" "iGateway" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = format("%s", var.envPrefix)
    },
    var.default_tags,
    #var.igw_tags,
  )
}

# create a Public subnet
resource "aws_subnet" "lb_subnet_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.lb_subnet_a_cidr
  availability_zone       = element(split(",", var.azs), 0)
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = format("%s-lb_subnet_a", var.envPrefix)
    },
    var.default_tags,
    # var.public_subnet_tags,
  )
}

# create a public subnet
resource "aws_subnet" "lb_subnet_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.lb_subnet_b_cidr
  availability_zone       = element(split(",", var.azs), 1)
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = format("%s-lb_subnet_b", var.envPrefix)
    },
    var.default_tags,
    # var.public_subnet_tags,
  )
}

# create a private subnet
resource "aws_subnet" "web_subnet_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.web_subnet_a_cidr
  availability_zone       = element(split(",", var.azs), 0)
  map_public_ip_on_launch = false

  tags = merge(
    {
      "Name" = format("%s-web_subnet_a", var.envPrefix)
    },
    var.default_tags,
    # var.public_subnet_tags,
  )
}

# create a private subnet
resource "aws_subnet" "web_subnet_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.web_subnet_b_cidr
  availability_zone       = element(split(",", var.azs), 1)
  map_public_ip_on_launch = false

  tags = merge(
    {
      "Name" = format("%s-web_subnet_b", var.envPrefix)
    },
    var.default_tags,
    # var.public_subnet_tags,
  )
}

# create a subnet suaitable for DB placement
resource "aws_subnet" "db_subnet_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.db_subnet_a_cidr
  availability_zone       = element(split(",", var.azs), 0)
  map_public_ip_on_launch = false

  tags = merge(
    {
      "Name" = format("%s-db_subnet_a", var.envPrefix)
    },
    var.default_tags,
    # var.public_subnet_tags,
  )
}

# create a subnet suaitable for DB placement
resource "aws_subnet" "db_subnet_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.db_subnet_b_cidr
  availability_zone       = element(split(",", var.azs), 1)
  map_public_ip_on_launch = false

  tags = merge(
    {
      "Name" = format("%s-db_subnet_b", var.envPrefix)
    },
    var.default_tags,
    # var.public_subnet_tags,
  )
}

# create route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = merge({
    "Name" = format("%s-RTB-Public", var.envPrefix)
    },
    var.default_tags,
  )
}

# Build additional private subnet resource
resource "aws_subnet" "public_subnet" {
  count      = length(var.pub_additional-subnet-mapping)
  vpc_id     = aws_vpc.this.id
  cidr_block = lookup(var.pub_additional-subnet-mapping[count.index], "cidr")
  # cidr_block = element(var.public_subnet_cidr, count.index)
  availability_zone       = lookup(var.pub_additional-subnet-mapping[count.index], "az")
  map_public_ip_on_launch = true
  tags = merge(
    {
      "Name" = format("%s-%s", var.envPrefix, lookup(var.pub_additional-subnet-mapping[count.index], "name"))
    },
    var.default_tags,
  )
}

# Build additional private subnet resource
resource "aws_subnet" "private_subnet" {
  count      = length(var.prv_additional-subnet-mapping)
  vpc_id     = aws_vpc.this.id
  cidr_block = lookup(var.prv_additional-subnet-mapping[count.index], "cidr")
  # cidr_block = element(var.public_subnet_cidr, count.index)
  availability_zone       = lookup(var.prv_additional-subnet-mapping[count.index], "az")
  map_public_ip_on_launch = false
  tags = merge(
    {
      "Name" = format("%s-%s", var.envPrefix, lookup(var.prv_additional-subnet-mapping[count.index], "name"))
    },
    var.default_tags,
  )
}

# add egress route to the route table to provide internet access
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.iGateway.id

}

# create route table subnet association where required.
resource "aws_route_table_association" "lb1_pub" {
  subnet_id      = aws_subnet.lb_subnet_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "lb2_pub" {
  subnet_id      = aws_subnet.lb_subnet_b.id
  route_table_id = aws_route_table.public.id
}
# create route table subnet association where required.
resource "aws_route_table_association" "public_route_table" {
  count          = length(var.pub_additional-subnet-mapping)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}


# Create Elastic IP for NAT Gateway
resource "aws_eip" "natgw-eip" {
  count = var.enable_nat_gateway ? 1 : 0
  vpc = true
  tags = merge(
    {
      "Name" = format("%s-EIP", var.envPrefix)
    },
    var.default_tags,
    #var.igw_tags,
  )
}

#Create NAT Gateway
resource "aws_nat_gateway" "nat-gateway" {
  count = var.enable_nat_gateway ? 1 : 0
  #count = var.enable_nat_gateway == "true"
  #allocation_id = aws_eip.natgw-eip.id
  allocation_id=aws_eip.natgw-eip[count.index].id
  subnet_id     = aws_subnet.lb_subnet_a.id
  depends_on    = [aws_internet_gateway.iGateway]
  tags = merge(
    {
      "Name" = format("%s-NAT", var.envPrefix)
    },
    var.default_tags,
    #var.igw_tags,
  )
}

# Create the Route for NAT Gateway
resource "aws_route_table" "nat_t-gw-vpc-route-table-private" {
  # count = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.enable_nat_gateway ? aws_nat_gateway.nat-gateway[0].id : null
    transit_gateway_id = var.enable_nat_gateway ? null: var.transit_gateway_id 
  }
  tags = merge(
    {
      "Name" = format("%s-RT-Private", var.envPrefix)
    },
    var.default_tags,
    #var.igw_tags,
  )
}
# Add Private web Subnet 1 Routes
resource "aws_route_table_association" "rt-private-subnet-a" {
  #  count = var.enable_nat_gateway ? 1 : 0
  subnet_id      = aws_subnet.web_subnet_a.id
  route_table_id = aws_route_table.nat_t-gw-vpc-route-table-private.id
}

# Add Private web Subnet 2 Routes
resource "aws_route_table_association" "rt-private-subnet-b" {
  # count = var.enable_nat_gateway ? 1 : 0
  subnet_id      = aws_subnet.web_subnet_b.id
  route_table_id = aws_route_table.nat_t-gw-vpc-route-table-private.id
}

# Add Private database Subnet 1 Routes
resource "aws_route_table_association" "rt-private-dbsubnet-a" {
  # count = var.enable_nat_gateway ? 1 : 0
  subnet_id      = aws_subnet.db_subnet_a.id
  route_table_id = aws_route_table.nat_t-gw-vpc-route-table-private.id
}

# Add Private database Subnet 2 Routes
resource "aws_route_table_association" "rt-private-dbsubnet-b" {
  # count = var.enable_nat_gateway ? 1 : 0
  subnet_id      = aws_subnet.db_subnet_b.id
  route_table_id = aws_route_table.nat_t-gw-vpc-route-table-private.id
}
# create route table subnet association where required.
resource "aws_route_table_association" "rt-private-additionalsubnet-a" {
  count          = length(var.prv_additional-subnet-mapping)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.nat_t-gw-vpc-route-table-private.id
}

resource "aws_vpc_endpoint" "s3" {
  count           = var.enable_vpc_endpoint_s3 ? 1 : 0
  vpc_id          = aws_vpc.this.id
  service_name    = join(".", ["com.amazonaws", var.region, "s3"])
  route_table_ids = [aws_route_table.public.id]
}
resource "aws_vpc_endpoint" "dynamo_DB" {
  count           = var.enable_vpc_endpoint_dynamodb ? 1 : 0
  vpc_id          = aws_vpc.this.id
  service_name    = join(".", ["com.amazonaws", var.region, "dynamodb"])
  route_table_ids = [aws_route_table.public.id]
}
resource "aws_flow_log" "vpc_flowlogs" {
  count                = "${var.environment_type == "production" ? 1 : 0}"
  log_destination      = var.log_destination
  log_destination_type = var.log_destination_type
  iam_role_arn         = aws_iam_role.vpc_flow_role[count.index].arn
  vpc_id               = aws_vpc.this.id
  traffic_type         = "ALL"
  tags                 = var.default_tags
}
resource "aws_iam_role" "vpc_flow_role" {
  count = var.enable_cloudwatch_role_for_flowlogs ? 1: 0
  name               = "${var.envPrefix}-VPC_flow_role"
  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "vpc-flow-logs.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": "VisualEditor1"
        }
      ]
    }
EOF
}

resource "aws_iam_role_policy_attachment" "policy_vpc" {
  count = var.enable_cloudwatch_role_for_flowlogs ? 1: 0
  role       = aws_iam_role.vpc_flow_role[count.index].name
  policy_arn = aws_iam_policy.roleforvpcflowlogs[count.index].arn
}

resource "aws_iam_policy" "roleforvpcflowlogs" {
  count = var.enable_cloudwatch_role_for_flowlogs ? 1: 0
  name   = "${var.envPrefix}-VPC_flowlogs_Policy"
  path   = "/"
  policy = data.aws_iam_policy_document.flowlogs_policy.json
}

data "aws_iam_policy_document" "flowlogs_policy" {
  statement {
    sid       = "VisualEditor0"
    effect    = "Allow"
    resources = ["*"]
    actions = [
   "logs:CreateLogStream",
   "logs:DescribeLogGroups",
   "logs:DescribeLogStreams",
   "logs:CreateLogGroup",
   "logs:PutLogEvents"
    ]
  }
}


resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  count = var.enable_nat_gateway ? 0: 1
  subnet_ids         = [aws_subnet.web_subnet_a.id,aws_subnet.db_subnet_b.id]
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = aws_vpc.this.id
  transit_gateway_default_route_table_association =false
  transit_gateway_default_route_table_propagation = false

  tags = merge(
    {
      "Name" = format("%s-tg-attachment", var.envPrefix)
    },
    var.default_tags,
  )

}

data "aws_route_table" "Egress_VPC_Public_Route_Table" {
  count = var.enable_nat_gateway ? 0: 1
  route_table_id = var.egress_vpc_public_RT_id
}

resource "aws_ec2_transit_gateway_route_table" "app_route_table" {
  count = var.enable_nat_gateway ? 0: 1
  transit_gateway_id = var.transit_gateway_id
  tags =  merge({
    "Name" = format("%s-TG-RTB", var.envPrefix)
    },
    var.default_tags,
  )
}


resource "aws_ec2_transit_gateway_route_table_association" "twg_association" {
  count = var.enable_nat_gateway ? 0: 1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.app_route_table[0].id
}


resource "aws_ec2_transit_gateway_route" "App-Route" {
  count = var.tg_rtb_blackhole  ? 1: 0
  destination_cidr_block         = var.cidr
  blackhole                      = true
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.app_route_table[0].id
  lifecycle {
    precondition {
      condition     = var.enable_nat_gateway == false
      error_message = "App route in TG-RTB will be created when nat gateway is false"
    }
  }
}

resource "aws_ec2_transit_gateway_route" "App-Route_peering" {
  count = var.vpc_peering ? 1: 0
  destination_cidr_block         = var.cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.app_route_table[0].id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[0].id
  lifecycle {
    precondition {
      condition     = var.enable_nat_gateway == false
      error_message = "Peering connection through TG will be possible when nat gateway is false"
    }
    precondition {
      condition     = var.tg_rtb_blackhole == false
      error_message = "Peering connection through TG will be possible tg_rtb_blackhole is false"
    }
  }
  depends_on = [ aws_ec2_transit_gateway_route.App-Route ]
}

resource "aws_ec2_transit_gateway_route" "peering_app_vpc" {
  count = var.vpc_peering ? 1: 0
  destination_cidr_block         = var.peering_cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.app_route_table[0].id
  transit_gateway_attachment_id  = var.peering_tg_attachement_id
  lifecycle {
    precondition {
      condition     = var.enable_nat_gateway == false
      error_message = "Peering connection through TG will be possible when nat gateway is false"
    }
    precondition {
      condition     = var.tg_rtb_blackhole == false
      error_message = "Peering connection through TG will be possible when tg_rtb_blackhole is false"
    }
  }
  depends_on = [ aws_ec2_transit_gateway_route.App-Route ]
}


data "aws_ec2_transit_gateway_route_table" "Egress-Route-Table" {
  count = var.enable_nat_gateway ? 0: 1
  id = var.tg_egress_route_table_id
}

resource "aws_ec2_transit_gateway_route" "Egress-Route" {
  count = var.enable_nat_gateway ? 0: 1
  destination_cidr_block         = var.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[0].id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.Egress-Route-Table[0].id
}

resource "aws_route" "route" {
  depends_on = [
    aws_ec2_transit_gateway_route_table_association.twg_association
  ]
  count = var.enable_nat_gateway ? 0: 1
  route_table_id            = data.aws_route_table.Egress_VPC_Public_Route_Table[0].id
  destination_cidr_block    = var.cidr
  transit_gateway_id =  var.transit_gateway_id
}

resource "aws_ec2_transit_gateway_route" "App-rtb_egress_route" {
  count = var.enable_nat_gateway ? 0: 1
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = var.egress_vpc_tg_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.app_route_table[0].id
}