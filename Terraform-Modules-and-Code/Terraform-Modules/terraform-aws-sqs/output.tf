output "queue_id" {
  description = "The sqs queue URL"
  value = aws_sqs_queue.sqs_queue.id
}
output "queue_arn" {
  description = "The sqs queue arn"
  value = aws_sqs_queue.sqs_queue.arn
}
