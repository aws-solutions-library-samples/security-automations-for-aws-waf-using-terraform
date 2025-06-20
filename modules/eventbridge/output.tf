output "arn" {
  description = "arn value of the event rule"
  value       = try(aws_cloudwatch_event_rule.trigger[0].arn, null)
}