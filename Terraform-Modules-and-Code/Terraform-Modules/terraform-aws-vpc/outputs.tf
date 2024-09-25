output "vpc_id" {
  value = aws_vpc.this.id
}
output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}
output "account_id" {
  value = "data.aws_caller_identity.current.account_id"
}
output "lb_subnet_a_id" {
  value = aws_subnet.lb_subnet_a.id
}

output "lb_subnet_b_id" {
  value = aws_subnet.lb_subnet_b.id
}

output "web_subnet_a_id" {
  value = aws_subnet.web_subnet_a.id
}

output "web_subnet_b_id" {
  value = aws_subnet.web_subnet_b.id
}

output "db_subnet_a_id" {
  value = aws_subnet.db_subnet_a.id
}

output "db_subnet_b_id" {
  value = aws_subnet.db_subnet_b.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.*.id
}
output "private_subnet_id" {
  value = aws_subnet.private_subnet.*.id
}
