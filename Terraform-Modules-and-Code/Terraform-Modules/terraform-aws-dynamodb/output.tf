output "dynamoDB_id" {
  description = "The ID of the dynamoDB"
  value       = aws_dynamodb_table.dynamodb_table.id
}