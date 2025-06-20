variable "name" {
  description = "Use an existing S3 bucket for Athena query results if `create_s3_bucket` is `false`."
  type        = string
  default     = null
}

variable "description" {
  description = "Use an existing S3 bucket for Athena query results if `create_s3_bucket` is `false`."
  type        = string
  default     = null
}

variable "state" {
  description = "Use an existing S3 bucket for Athena query results if `create_s3_bucket` is `false`."
  type        = string
  default     = "ENABLED"
}

variable "publish_cloudwatch_metrics_enabled" {
  description = "Boolean whether Amazon CloudWatch metrics are enabled for the workgroup."
  type        = bool
  default     = true
}

variable "workgroup_encryption_option" {
  description = "Indicates whether Amazon S3 server-side encryption with Amazon S3-managed keys (SSE_S3), server-side encryption with KMS-managed keys (SSE_KMS), or client-side encryption with KMS-managed keys (CSE_KMS) is used."
  type        = string
  default     = "SSE_KMS"
}

variable "kms_key_arn" {
  description = "The S3 bucket path used to store query results."
  type        = string
  default     = ""
}

variable "output_location" {
  description = "State of the workgroup. Valid values are `DISABLED` or `ENABLED`."
  type        = string
  default     = ""
}

variable "workgroup_force_destroy" {
  description = "The option to delete the workgroup and its contents even if the workgroup contains any named queries."
  type        = bool
  default     = false
}