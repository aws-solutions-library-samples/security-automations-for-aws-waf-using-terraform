resource "aws_lambda_function" "lambda" {
  #checkov:skip=CKV_AWS_116: "Ensure that AWS Lambda function is configured for a Dead Letter Queue(DLQ)"
  #checkov:skip=CKV_AWS_117: "Ensure that AWS Lambda function is configured inside a VPC"
  #checkov:skip=CKV_AWS_173: "Check encryption settings for Lambda environmental variable"
  #checkov:skip=CKV_AWS_272: "Ensure AWS Lambda function is configured to validate code-signing"
  count                          = var.create_lambda ? 1 : 0
  function_name                  = var.function_name
  description                    = var.description
  role                           = var.role_arn
  handler                        = var.handler
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.runtime
  s3_bucket                      = var.s3_bucket
  s3_key                         = var.s3_key
  kms_key_arn                    = var.kms_key_arn
  timeout                        = var.timeout

  # Add dynamic blocks based on variables.
  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }
  tracing_config {
    mode = "Active"
  }
}


resource "aws_lambda_permission" "this" {
  count          = var.create_lambda_invoke_permission ? 1 : 0
  action         = "lambda:InvokeFunction"
  function_name  = var.function_name == "" ? aws_lambda_function.lambda[count.index].function_name : var.function_name
  principal      = var.permission_principal
  source_account = var.permission_source_account == "" ? null : var.permission_source_account
  source_arn     = try(var.permission_source_arn, null)
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "yada" {
  #checkov:skip=CKV_AWS_158: "Ensure that CloudWatch Log Group is encrypted by KMS"
  name              = "/aws/lambda/${aws_lambda_function.lambda[0].function_name}"
  retention_in_days = var.retention_in_days
}