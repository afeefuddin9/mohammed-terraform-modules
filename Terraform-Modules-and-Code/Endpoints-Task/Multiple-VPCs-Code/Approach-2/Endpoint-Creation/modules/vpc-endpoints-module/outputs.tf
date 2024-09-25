# outputs.tf

output "security_group_ids" {
  value = aws_security_group.endpoint
}

output "route_table_ids" {
  value = aws_route_table.private
}

output "vpc_endpoints" {
  value = {
    lambda  = aws_vpc_endpoint.lambda
    ec2     = aws_vpc_endpoint.ec2
    s3      = aws_vpc_endpoint.s3
    ecr_dkr = aws_vpc_endpoint.ecr_dkr
    ecr_api = aws_vpc_endpoint.ecr_api
  }
}
