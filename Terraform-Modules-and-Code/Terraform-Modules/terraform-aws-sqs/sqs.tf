resource "aws_sqs_queue" "sqs_queue" {
  name = "${var.queue_name}-queue.fifo"
  message_retention_seconds         = var.message_retention_seconds
  max_message_size                  = var.max_message_size
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.content_based_deduplication
 # kms_master_key_id                 = var.kms_master_key_id
 # kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
   tags = var.default_tags
}