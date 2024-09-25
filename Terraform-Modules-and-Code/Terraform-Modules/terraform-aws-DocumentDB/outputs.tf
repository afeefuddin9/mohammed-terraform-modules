output "arn" {
  value       = aws_docdb_cluster.DocDB_cluster.arn
  description = "Amazon Resource Name (ARN) of the DocumentDB cluster"
}
output "endpoint" {
  value       = aws_docdb_cluster.DocDB_cluster.endpoint
  description = "Endpoint of the DocumentDB cluster"
}
output "reader_endpoint" {
  value       = aws_docdb_cluster.DocDB_cluster.reader_endpoint
  description = "Read-only endpoint of the DocumentDB cluster, automatically load-balanced across replicas"
}
