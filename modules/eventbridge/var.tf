variable "name" {
  description = "Name of the CloudWatch Event trigger"
  default     = ""
}

variable "description" {
  description = "Trigger description"
  default     = ""
}

variable "enabled" {
  default = "true"
}

variable "frequency_type" {
  description = "A predefined frequency for scheduled triggering (required if `trigger_arn` not specified)"
  default     = "hourly_on_weekdays"
}

variable "target_arn" {
  description = "ARN of the CloudWatch Event target"
  default     = ""
}

variable "target_id" {
  description = "Target id"
  default     = ""
}

variable "input" {
  description = "input"
  default     = ""
}

variable "event_pattern" {
  description = "event_pattern"
  default     = null
}

variable "permission_principal" {
  type    = string
  default = ""
}

variable "permission_source_account" {
  type    = string
  default = ""
}

variable "permission_source_arn" {
  type    = string
  default = ""
}

variable "create_lambda_invoke_permission" {
  type    = string
  default = false
}

variable "create_event_rule" {
  type    = string
  default = false
}

variable "function_name" {
  type    = string
  default = ""
}