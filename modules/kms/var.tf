variable "description" {
  description = "The description of this KMS key"
  type        = string
}

variable "enable_key_rotation" {
  description = "(Optional) Specifies whether key rotation is enabled. Defaults to false."
  type        = bool
  default     = true
}