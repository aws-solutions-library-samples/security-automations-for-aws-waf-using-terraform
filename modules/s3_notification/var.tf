variable "create_notification" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = false
}

variable "lambda_notifications" {
  description = "Map of S3 bucket notifications to Lambda function"
  type        = any
  default     = {}
}

variable "bucket" {
  description = "Bucket where you need to configure the event"
  type        = any
  default     = {}
}