variable "name" {
  description = "sns name"
  type        = string
  default     = null
}

variable "kms_master_key_id" {
  description = "kms_master_key_id"
  type        = string
  default     = null
}

variable "protocol" {
  description = "protocol"
  type        = string
  default     = null
}

variable "SNSEmailParam" {
  description = "SNSEmailParam"
  type        = string
  default     = null
}