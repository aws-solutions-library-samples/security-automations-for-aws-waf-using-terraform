output "dynamodb_arn" {
  description = "dynamodb table arn"
  value       = try(aws_dynamodb_table.this.arn, null)
}

output "dynamodb_stream_arn" {
  description = "dynamodb table stream arn"
  value       = try(aws_dynamodb_table.this.stream_arn, null)
}