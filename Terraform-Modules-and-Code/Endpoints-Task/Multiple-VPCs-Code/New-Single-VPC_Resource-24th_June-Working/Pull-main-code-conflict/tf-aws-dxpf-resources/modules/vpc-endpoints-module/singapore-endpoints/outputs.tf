output "s3_endpoint_id" {
  value = aws_vpc_endpoint.s3.id
}

output "lambda_endpoint_id" {
  value = aws_vpc_endpoint.lambda.id
}

output "ec2_endpoint_id" {
  value = aws_vpc_endpoint.ec2.id
}

output "ecr_dkr_endpoint_id" {
  value = aws_vpc_endpoint.ecr_dkr.id
}

output "ecr_api_endpoint_id" {
  value = aws_vpc_endpoint.ecr_api.id
}
