output "glue_database_name" {
  description = "GLUE database Name"
  value       = try(module.glue_catalog_database[0].name, "0")
}

output "waf_access_logs_table_name" {
  description = "WAF access logs table name"
  value       = try(module.waf_access_logs_table[0].name, "0")
}

output "alb_glue_app_access_logs_table_name" {
  description = "ALB GLUE App access logs table name"
  value       = try(module.alb_glue_app_access_logs_table[0].name, "0")
}

output "cloudfront_glue_app_access_logs_table_name" {
  description = "cloud front GLUE App access logs table name"
  value       = try(module.cloudfront_glue_app_access_logs_table[0].name, "0")
}

output "waf_add_partition_athena_query_workgroup_name" {
  description = "WAF athena query work group name"
  value       = try(module.waf_add_partition_athena_query_workgroup[0].athena_workgroup_name, "0")
}

output "waf_log_athena_query_workgroup_name" {
  description = "waf Log athena work group name"
  value       = try(module.waf_log_athena_query_workgroup[0].athena_workgroup_name, "0")
}

output "waf_app_access_log_athena_query_workgroup_name" {
  description = "waf App access log athena work group name "
  value       = try(module.waf_app_access_log_athena_query_workgroup[0].athena_workgroup_name, "0")
}

output "add_athena_partitions_lambda_arn" {
  description = "lambda function arn"
  value       = try(module.add_athena_partitions_aws_lambda_function[0].lambda_arn, "0")
}

output "add_athena_partitions_lambda_name" {
  description = "lambda function name"
  value       = try(module.add_athena_partitions_aws_lambda_function[0].lambda_name, "0")
}

output "firehouse_arn" {
  description = "dynamodb table arn"
  value       = try(module.firehose_athena[0].firehouse_arn, "0")
}