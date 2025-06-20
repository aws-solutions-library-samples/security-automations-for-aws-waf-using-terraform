output "sns_arn" {
  description = "sns arn"
  value       = try(aws_sns_topic.this.arn, null)
}