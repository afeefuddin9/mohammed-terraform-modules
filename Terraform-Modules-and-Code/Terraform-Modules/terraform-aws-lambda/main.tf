resource aws_lambda_function Lambda_function {
  function_name = var.lambdaFunctionName
  filename                       = "${var.lambdaFunctionName}.zip"
  role                           = var.role_arn
  handler                        = "${var.lambdaFunctionName}_handler"
  runtime                        = var.runtime
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.concurrency
  timeout                        = var.lambda_timeout
  tags                           = var.default_tags
  layers = aws_lambda_layer_version.lambda_layer[*].arn
  vpc_config {
    subnet_ids = var.enable_vpc ? var.subnet_id : []
    security_group_ids = var.enable_vpc ? var.sg_id : []
  }
  environment {
    variables = var.env_vars
  }
}
resource "aws_lambda_layer_version" "lambda_layer" {
  count = var.create_lambda_layer ? 1 : 0
  filename   = "${var.lambdaFunctionName}.zip"
  layer_name = var.layer_name
  compatible_runtimes = [var.runtime]
}
resource "aws_lambda_function_event_invoke_config" "example" {
  count = var.create_event_invoke ? 1 : 0
  function_name                = aws_lambda_function.Lambda_function.function_name
  maximum_event_age_in_seconds = var.maximum_event_age_in_seconds
  maximum_retry_attempts       = var.maximum_retry_attempts
}
