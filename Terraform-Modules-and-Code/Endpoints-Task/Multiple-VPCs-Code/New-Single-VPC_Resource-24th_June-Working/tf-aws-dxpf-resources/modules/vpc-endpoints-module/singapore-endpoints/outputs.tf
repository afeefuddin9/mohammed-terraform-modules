# output "s3_endpoint_id" {
#   #value = aws_vpc_endpoint.s3.id
#   value = aws_vpc_endpoint.s3[each.key]
# }

# output "lambda_endpoint_id" {
#   #value = aws_vpc_endpoint.lambda.id
#   value = aws_vpc_endpoint.lambda[each.key]
# }

# output "ec2_endpoint_id" {
#   #value = aws_vpc_endpoint.ec2.id
#   value =   aws_vpc_endpoint.ec2[each.key]
# }

# output "ecr_dkr_endpoint_id" {
#   #value = aws_vpc_endpoint.ecr_dkr.id
#   value =  aws_vpc_endpoint.ecr_dkr[each.key]
# }

# output "ecr_api_endpoint_id" {
#   #value = aws_vpc_endpoint.ecr_api.id,
#   value =  aws_vpc_endpoint.ecr_api[each.key]
# }

# output "az_to_subnet_ids" {
#   value = local.az_to_subnet_ids
# }

# output "selected_subnet_ids" {
#   value = [for az in keys(local.az_to_subnet_ids[var.vpc_ids_singapore[0]]) : local.az_to_subnet_ids[var.vpc_ids_singapore[0]][az]]
# }

