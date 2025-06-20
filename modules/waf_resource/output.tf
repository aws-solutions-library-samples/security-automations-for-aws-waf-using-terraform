output "moves3logsforpartition_lambda_arn" {
  description = "lambda function arn"
  value       = try(module.moves3logsforpartition_aws_lambda_function[0].lambda_arn, "0")
}

output "moves3logsforpartition_lambda_name" {
  description = "lambda function name"
  value       = try(module.moves3logsforpartition_aws_lambda_function[0].lambda_name, "0")
}

output "log_parser_lambda_arn" {
  description = "lambda function arn"
  value       = try(module.log_parser_aws_lambda_function[0].lambda_arn, "0")
}

output "log_parser_lambda_name" {
  description = "lambda function name"
  value       = try(module.log_parser_aws_lambda_function[0].lambda_name, "0")
}

output "helper_lambda_arn" {
  description = "lambda function arn"
  value       = try(module.helper_aws_lambda_function.lambda_arn, "0")
}

output "helper_lambda_name" {
  description = "lambda function name"
  value       = try(module.helper_aws_lambda_function.lambda_name, "0")
}

output "reputation_lists_parser_lambda_arn" {
  description = "lambda function arn"
  value       = try(module.reputation_lists_parser_aws_lambda_function[0].lambda_arn, "0")
}

output "reputation_lists_parser_lambda_name" {
  description = "lambda function name"
  value       = try(module.reputation_lists_parser_aws_lambda_function[0].lambda_name, "0")
}

output "custom_resource_lambda_arn" {
  description = "lambda function arn"
  value       = try(module.custom_resource_aws_lambda_function[0].lambda_arn, "0")
}

output "custom_resource_lambda_name" {
  description = "lambda function name"
  value       = try(module.custom_resource_aws_lambda_function[0].lambda_name, "0")
}

output "waf_acl_arn" {
  description = "The aws_iam_role object."
  value       = try(module.waf_acl[0].waf_acl_arn, "0")
}

output "waf_acl_name" {
  description = "The WAF name object."
  value       = try(module.waf_acl[0].waf_acl_name, "0")
}

output "result_entry" {
  value = try(jsondecode(aws_lambda_invocation.UpdateReputationListsOnLoad[0].result)["key1"], "0")
}

output "rest_api_id" {
  value = try(module.api_gateway[0].rest_api_id, "0")
}