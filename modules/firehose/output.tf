output "firehouse_arn" {
  description = "dynamodb table arn"
  value       = try(aws_kinesis_firehose_delivery_stream.FirehoseAthena.arn, null)
}