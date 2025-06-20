variable "stage_name" {
  description = "api stage name"
  type        = string
  default     = null
}

variable "api_stage" {
  description = "api stage"
  type        = string
  default     = null
}

variable "name" {
  description = "API name"
  type        = string
  default     = null
}

variable "description" {
  description = "API description"
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "kms key arn"
  type        = string
  default     = null
}

variable "cloudwatch_role_arn" {
  description = "cloudwatch role arn"
  type        = string
  default     = null
}

variable "uri" {
  description = "URI value"
  type        = string
  default     = null
}

variable "function_name" {
  description = "Function name"
  type        = string
  default     = null
}