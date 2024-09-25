terraform {
  required_providers {
    aws = {
      source  = hashicorpaws
      version = ~ 5.0
    }
  }
  required_version = = 1.7.5
}

provider aws {
  region = us-west-2
}

data aws_vpcs all_vpcs {}

data aws_vpc vpc_names {
  for_each = { for vpc_id in data.aws_vpcs.all_vpcs.ids  vpc_id = vpc_id }
  id       = each.value
}

output vpc_info {
  value = {
    for id, vpc in data.aws_vpc.vpc_names  id = {
      name = lookup(vpc.tags, Name, Name not found)
      id   = id
    }
  }
}
