output "rds_endpoint" {
  value = aws_db_instance.mysql_db.endpoint
}
output "rds_address" {
  value = aws_db_instance.mysql_db.address
}

output "rds_port" {
  value = aws_db_instance.mysql_db.port
}

output "rds_resource_id" {
  value = aws_db_instance.mysql_db.resource_id
}