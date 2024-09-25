# Output the EC2 VPC endpoint ID and DNS name
output "vpc_endpoints" {
  value = {
    ec2     = aws_vpc_endpoint.ec2
    s3      = aws_vpc_endpoint.s3
    lambda      = aws_vpc_endpoint.lambda
    ecr_dkr      = aws_vpc_endpoint.ecr_dkr
    ecr_api      = aws_vpc_endpoint.ecr_api
  }
}


output "ec2_vpc_sg" {
  value = aws_security_group.endpoint
}



# output "s3_vpc_endpoint_dns_name" {
#   value = aws_vpc_endpoint.s3.dns_entry[0].dns_name
# }