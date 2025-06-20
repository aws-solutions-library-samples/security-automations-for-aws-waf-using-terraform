resource "aws_kinesis_firehose_delivery_stream" "FirehoseAthena" {
  name        = var.DeliveryStreamName
  destination = "extended_s3"
  server_side_encryption {
    key_type = "CUSTOMER_MANAGED_CMK"
    enabled  = "true"
    key_arn  = var.kms_key_arn
  }
  extended_s3_configuration {
    bucket_arn          = var.bucket_arn
    compression_format  = "GZIP"
    error_output_prefix = "AWSErrorLogs/result=!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
    role_arn            = var.firehouseathena_rolearn
    buffering_size      = 5
    buffering_interval  = 300
  }
}