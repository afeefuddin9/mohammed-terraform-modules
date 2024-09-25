resource "aws_glue_connection" "glue_network_connection" {
  connection_type = "NETWORK"
  description     = "${var.envPrefix} Glue network Connection"
  name            = "${var.envPrefix}-glue-connection"
  tags            = var.default_tags
  physical_connection_requirements {
    availability_zone      = var.availability_zone
    security_group_id_list = [aws_security_group.sg_for_glue_job.id]
    subnet_id              = var.subnet_id
  }
}
resource "aws_glue_job" "glue_job" {
  name            = "${var.envPrefix}-glue-job"
  role_arn        = aws_iam_role.glue_service_role.arn
  connections     = [aws_glue_connection.glue_network_connection.name]
  description     = "${var.envPrefix} glue job"
  execution_class =  var.execution_class
  timeout         = var.timeout
  tags            = var.default_tags
  command {
    name            = "pythonshell"
    script_location = "s3://${var.s3_bucket}/${aws_s3_object.snowflake_script.key}"
    python_version  = var.python_version
  }
  default_arguments = var.default_arguments
}
resource "aws_s3_object" "snowflake_script" {
  bucket = var.s3_bucket
  key    = var.s3_object_key
  source = "modules/glue/glue-assets/snowflake_test.py"
}
resource "aws_cloudwatch_log_group" "log_group_glue" {
  name              = "${var.envPrefix}_glue_log_group"
  retention_in_days = var.retention_in_days
}