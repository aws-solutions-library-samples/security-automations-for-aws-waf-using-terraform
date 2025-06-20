output "lambda_arn" {
  description = "lambda function arn"
  value       = try(aws_lambda_function.lambda[0].arn, null)
}

output "lambda_name" {
  description = "lambda function name"
  value       = try(aws_lambda_function.lambda[0].function_name, null)
}