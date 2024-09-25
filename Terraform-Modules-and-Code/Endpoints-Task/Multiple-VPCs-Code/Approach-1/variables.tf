variable "vpc_ids" {
  description = "List of VPC IDs"
  type        = list(string)
  default     = [
    "vpc-041a1132552c39c34"
  ]
}

variable "route_table_ids" {
  description = "List of route table IDs"
  type        = list(string)
  default     = ["rtb-0e21269e5ed53f2ed"]
}

variable "sg_id" {
  description = "Security Group ID"
  type        = string
  default     = "sg-0fa0fb81122e4cf3f"
}

variable "subnet_id" {
    description = "Subnet ID"
    type = string
    default = "subnet-0e1034a25147f7359"
  
}
variable "service_endpoints" {
  description = "Map of service endpoints"
  type        = map(object({
    service_name       = string
    vpc_endpoint_type  = string
  }))
  default     = {
    lambda = {
      service_name       = "com.amazonaws.us-west-2.lambda"
      vpc_endpoint_type  = "Interface"
    }
    s3 = {
      service_name       = "com.amazonaws.us-west-2.s3"
      vpc_endpoint_type  = "Gateway"
    }
    ec2 = {
      service_name       = "com.amazonaws.us-west-2.ec2"
      vpc_endpoint_type  = "Interface"
    }
    ecr = {
      service_name       = "com.amazonaws.us-west-2.ecr.dkr"
      vpc_endpoint_type  = "Interface"
    }
  }
}
