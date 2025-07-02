locals {
  SNSEmail = var.IPRetentionPeriod == "yes" ? "yes" : "no"
  run_time = "python3.9"
}

variable "SNSEmailParam" {
  description = "SNS notification value"
  type        = string
  default     = "tamilver@amazon.com"
}

variable "MetricsURL" {
  description = "Metrics URL"
  type        = string
  default     = "https://metrics.awssolutionsbuilder.com/generic"
}
variable "SolutionID" {
  description = "UserAgent id value"
  type        = string
  default     = "SO0006-tf"
}

variable "SEND_ANONYMOUS_USAGE_DATA" {
  description = "Data collection parameter"
  type        = string
  default     = "yes"
}

variable "IPRetentionPeriod" {
  type        = string
  default     = "no"
  description = ""
  validation {
    condition     = contains(["yes", "no"], var.IPRetentionPeriod)
    error_message = "Invalid input, options: \"yes\",\"no\"."
  }
}

variable "random_id" {
  description = "SNS notification value"
  type        = string
}

variable "SourceBucket" {
  description = "Lambda source code bucket"
  type        = string
  default     = "solutions"
}

variable "source_version" {
  description = "source code version"
  type        = string
  default     = "v4.0.2"
}

variable "KeyPrefix" {
  description = "Keyprefix values for the lambda source code"
  type        = string
  default     = "security-automations-for-aws-waf/v4.0.2"
}

variable "kms_key_arn" {
  description = "ARN value of KMS KEY"
  type        = string
}

variable "LOG_LEVEL" {
  description = "Log level"
  type        = string
  default     = "INFO"
}

variable "USER_AGENT_EXTRA" {
  description = "UserAgent"
  type        = string
  default     = "AwsSolution/SO0006-tf/v4.0.2"
}

variable "IPRetentionPeriodAllowedParam" {
  description = "IP Retention Settings allowed value"
  type        = number
  default     = -1
}
variable "IPRetentionPeriodDeniedParam" {
  description = "IP Retention Settings denied value"
  type        = number
  default     = -1
}

variable "WAFWhitelistSetV6_arn" {
  description = "WAFWhitelistSetV6 arn"
  type        = string
}
variable "WAFBlacklistSetV6_arn" {
  description = "WAFBlacklistSetV6 arn"
  type        = string
}
variable "WAFWhitelistSetV4_arn" {
  description = "WAFWhitelistSetV4 arn"
  type        = string
}
variable "WAFBlacklistSetV4_arn" {
  description = "WAFBlacklistSetV4 arn"
  type        = string
}
variable "WAFWhitelistSetV4_name" {
  description = "WAFWhitelistSetV4 name"
  type        = string
}

variable "WAFBlacklistSetV6_name" {
  description = "WAFBlacklistSetV6 name"
  type        = string
}
variable "WAFWhitelistSetV6_name" {
  description = "WAFWhitelistSetV6 name"
  type        = string
}
variable "WAFBlacklistSetV4_name" {
  description = "WAFBlacklistSetV4 name"
  type        = string
}

variable "retention_in_days" {
  type    = number
  default = 365
}