variable "queue_name" {
  description = "Name of the queue"
}
variable "region" {
  description = "The AWS region."
}
variable "default_tags" {
  description = "The default tags to attach"
}
variable "message_retention_seconds" {
  description = "The message retention seconds"
}
variable "max_message_size" {
      description = "The Max message size"
}
variable "delay_seconds" {
      description = "The message delay second"
}
variable "receive_wait_time_seconds" {
      description = "The receive wait time seconds"
}
variable "fifo_queue" {
      description = "Enable the fifo queqe"
      default = "true"
}
variable "content_based_deduplication" {
      description = "Enable content based deduplication"
      default = "true"
}