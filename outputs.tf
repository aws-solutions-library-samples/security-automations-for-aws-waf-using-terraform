output "bad_bot_honey_end_point" {
  description = "URL of badbot-honeyendpoint"
  value       = "https://${module.waf_resource[0].rest_api_id}.execute-api.${data.aws_region.current.name}.amazonaws.com/${var.api_stage}"
}

output "badbot_honeyendpoint" {
  description = "URL of badbot-honeyendpoint"
  value       = "https://${module.waf_resource[0].rest_api_id}.execute-api.${data.aws_region.current.name}.amazonaws.com/${var.api_stage}"
}

output "badbot_ipv4_name" {
  description = "Name of badbot ipv4 set"
  value       = try(module.ip_sets.WAFBadBotSetV4_name, null)
}

output "app_access_log_bucket" {
  description = "Name of Application Access Log S3 Bucket"
  value       = try(module.s3_app_log_bucket[0].bucket_name, null)
}

output "waf_log_bucket" {
  description = "Name of WAF Log S3 Bucket "
  value       = try(module.s3_waf_log_bucket[0].bucket_name, null)
}

output "waf_web_acl" {
  description = "Name of WAF Web ACL"
  value       = try(module.waf_resource[0].waf_acl_name, null)
}

output "waf_acl_arn" {
  description = "ARN of WAF ACL"
  value       = try(module.waf_resource[0].waf_acl_arn, null)
} 