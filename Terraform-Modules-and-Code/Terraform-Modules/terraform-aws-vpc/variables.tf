variable "envPrefix" {
  description = "To define the env prefix"
  validation {
    condition     = length(var.envPrefix) > 0
    error_message = "envPrefix cannot be an empty string."
  }
}
variable "azs" {
  description = "comma separated ordered lists of (two) AZs in which to distribute subnets"
}

variable "cidr" {
  description = "define vpc cidr"
  validation {
        condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}($|/(23))$", var.cidr))
        error_message = "Vpc_cidr subnet mask should be end with /23 and only numbers are allowed in the IP range"
      }
}

variable "lb_subnet_a_cidr" {
    description = "define subnet cidr"
    validation {
        condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}($|/(25))$", var.lb_subnet_a_cidr))
        error_message = "subnet_cidr subnet mask should be end with /25 and only numbers are allowed in the IP range"
      }
}
variable "lb_subnet_b_cidr" {
    description = "define subnet cidr"
    validation {
        condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}($|/(25))$", var.lb_subnet_b_cidr))
        error_message = "subnet_cidr subnet mask should be end with /25 and only numbers are allowed in the IP range"
      }
}
variable "db_subnet_a_cidr" {
    description = "define subnet cidr"
    validation {
        condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}($|/(26))$", var.db_subnet_a_cidr))
        error_message = "subnet_cidr subnet mask should be end with /26 and only numbers are allowed in the IP range"
      }
}
variable "db_subnet_b_cidr" {
    description = "define subnet cidr"
    validation {
        condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}($|/(26))$", var.db_subnet_b_cidr))
        error_message = "subnet_cidr subnet mask should be end with /26 and only numbers are allowed in the IP range"
      }
}
variable "web_subnet_a_cidr" {
    description = "define subnet cidr"
    validation {
        condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}($|/(26))$", var.web_subnet_a_cidr))
        error_message = "subnet_cidr subnet mask should be end with /26 and only numbers are allowed in the IP range"
      }
}
variable "web_subnet_b_cidr" {
    description = "define subnet cidr"
    validation {
        condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}($|/(26))$", var.web_subnet_b_cidr))
        error_message = "subnet_cidr subnet mask should be end with /26 and only numbers are allowed in the IP range"
      }
}

variable "enable_dns_hostnames" {
  default = "true"
}

variable "enable_dns_support" {
  default = "true"
}
variable "enable_db_subnet_group" {
  description = "Set to true to create database subnet group for RDS"
  type        = bool
  default     = false
}
variable "default_tags" {
  type = map(string)
  validation {
    condition = alltrue([for tag in ["Project", "Billing", "Owner","Managed"] : contains(keys(var.default_tags),tag)])
    error_message = "Please include tags for Project, Billing, Owner and Managed."
    }
}
variable "prv_additional-subnet-mapping" {
  description = "Set to true to create database subnet group for RDS"
  default     = []
}
variable "pub_additional-subnet-mapping" {
  description = "Lists the subnets to be created in their respective AZ."
  default     = []
}
variable "enable_vpc_endpoint_dynamodb" {
  description = "Set a boolean value to enable or disable vpc endpoint for dynamo DB"
  default     = false
}
variable "enable_vpc_endpoint_s3" {
  description = "Set a boolean value to enable or disable vpc endpoint for S3"
  default     = false
}
variable "region" {
  description = "Define the region"
  type=string
  validation {
    condition= contains(["us-west-2", "ap-southeast-1","ap-northeast-1","us-east-1"], var.region)
    error_message="${var.region} region restricted from creating resources and allowed regions are 'us-west-2', 'ap-southeast-1','ap-northeast-1','us-east-1'"
  }
}
variable "environment_type" {
  description = "Set the environment type to enable or disable vpc flowlogs(If the value is production, the VPC flow logs will be enabled)"
  type=string
  validation {
    condition= contains(["Prod","Pre-Prod","QA", "Dev","Stable","Test"], var.environment_type)
    error_message="Provide a valid Environment like Prod,Pre-Prod,QA,Dev,Stable, or Test"
  }
}
variable "log_destination" {
  description = "Set flowlogs destination"
  default     = []
}
variable "log_destination_type" {
  description = "Set log destination type"
  default     = "s3"
}
variable "enable_cloudwatch_role_for_flowlogs" {
  description = "Define a boolean value to enable cloudwatch role for flowlogs"
  default     = false
}
variable "enable_nat_gateway" {
  description = "Define a boolean value to enable Nat Gateway"
  default     = false
  type = bool
}

variable "create_aws_eip" {
  description = "Depends on NAT Gateway"
  default     = false
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID"
  default     = ""
}

variable "tg_app_route_table_id" {
  description = "Transit Gateway Application Route Table"
  default     = ""
}

variable "tg_egress_route_table_id" {
  description = "Transit Gateway Egress Route Table"
  default     = ""
}

variable "egress_vpc_public_RT_id" {
  description = "Egress VPC Public Route Table ID"
  default     = ""
}

variable "egress_vpc_tg_attachment_id" {
  description = "Egress VPC tg ID"
  default     = ""
}

variable "vpc_peering" {
  description = "Define a boolean value to enable vpc peering"
  default     = false
  type = bool
}

variable "tg_rtb_blackhole" {
  description = "Define a boolean value to enable blackhole"
  default     = true
  type = bool
}

variable "peering_cidr" {
  description = "define peering vpc cidr"
  default     = ""
}

variable "peering_tg_attachement_id" {
  description = "peering vpc tg attachment id"
  default     = ""
}