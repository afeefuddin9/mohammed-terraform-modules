variable "aws_account_id" {
  description = "The AWS account ID"
}
variable "aws_region" {
  description = "Region of the AWS acccount"
}
variable "vpc_id" {
  description = "The VPC Id"
}
variable "s3_log_bucket_name" {
  description = "S3 logging target bucket name"
}
variable "python_version" {
}
variable "s3_object_key" {
}
variable "s3_bucket" {
}
variable "envPrefix" {
}
variable "availability_zone" {
}
variable "timeout" {
  default = "10"
}
variable "execution_class" {
  default = "STANDARD"
}
variable "subnet_id" {
}
variable "default_tags" {
}
variable "default_arguments" {
  type        = map(string)
  description = "default tags"
  default = {
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = "true"
    "--enable-job-insights"              = "false"
    "--enable-observability-metrics"     = "false"
    "--job-language"                     = "python"
  }
}
variable "retention_in_days" {
  default = "60"
}