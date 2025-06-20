variable "DeliveryStreamName" {
  description = "Name of the Delivery stream value"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key arn value"
}

variable "bucket_arn" {
  description = "Bucket arn"
}

variable "firehouseathena_rolearn" {
  description = "Firehouse arn"
}

