variable "ip_retention_period_allowed_param" {
  description = "IP Retention Settings allowed value"
  type        = number
  default     = -1
}
variable "ip_retention_period_denied_param" {
  description = "IP Retention Settings denied value"
  type        = number
  default     = -1
}


variable "key_prefix" {
  description = "Keyprefix values for the lambda source code"
  type        = string
  default     = "security-automations-for-aws-waf"
}

variable "sse_algorithm" {
  description = "sse_algorithm"
  type        = string
  default     = "aws:kms"
}

#ELigible for switch case

variable "end_point" {
  description = "cloudfront or ALB"
  type        = string
  default     = "cloudfront"
  validation {
    condition     = contains(["cloudfront", "ALB"], var.end_point)
    error_message = "Invalid input, options: \"cloudfront\",\"ALB\"."
  }
}

variable "user_agent_extra" {
  description = "UserAgent"
  type        = string
  default     = "AwsSolution/SO0006-tf"
}

variable "source_version" {
  description = "version"
  type        = string
  default     = "v4.0.2"
}

variable "send_anonymous_usage_data" {
  description = "Data collection parameter"
  type        = string
  default     = "yes"
}

variable "keep_original_data" {
  description = "S3 original data"
  type        = string
  default     = "No"
}

variable "waf_block_period" {
  description = "block period for Log Monitoring Settings"
  type        = number
  default     = 240
}
variable "error_threshold" {
  description = "error threshold for Log Monitoring Settings"
  type        = number
  default     = 50
}

variable "sns_email_param" {
  description = "SNS notification value"
  type        = string
  default     = ""
}

variable "activate_http_flood_protection_param" {
  type        = string
  default     = "yes - AWS WAF rate based rule"
  description = "activate_http_flood_protection_param"
  # using contains()
  validation {
    condition     = contains(["yes - AWS Lambda log parser", "yes - Amazon Athena log parser", "yes - AWS WAF rate based rule", "no"], var.activate_http_flood_protection_param)
    error_message = "Invalid input, options: \"yes - AWS Lambda log parser\", \"yes - Amazon Athena log parser\",\"yes - AWS WAF rate based rule\", \"no\"."
  }
}
variable "request_threshold" {
  description = "request threshold for Log Monitoring Settings"
  type        = number
  default     = 100
}


variable "activate_aws_managed_rules_param" {
  type        = string
  default     = "no"
  description = "activate_aws_managed_rules_param"
  # using contains()
  validation {
    condition     = contains(["yes", "no"], var.activate_aws_managed_rules_param)
    error_message = "Invalid input, options: \"yes\",\"no\"."
  }
}

variable "activate_sql_injection_protection_param" {
  type        = string
  default     = "yes"
  description = "activate_sql_injection_protection_param"
  # using contains()
  validation {
    condition     = contains(["yes", "no"], var.activate_sql_injection_protection_param)
    error_message = "Invalid input, options: \"yes\",\"no\"."
  }
}

variable "activate_cross_site_scripting_protection_param" {
  type        = string
  default     = "yes"
  description = "activate_cross_site_scripting_protection_param"
  # using contains()
  validation {
    condition     = contains(["yes", "no"], var.activate_cross_site_scripting_protection_param)
    error_message = "Invalid input, options: \"yes\",\"no\"."
  }
}

variable "activate_reputation_lists_protection_param" {
  type        = string
  default     = "yes"
  description = "activate_reputation_lists_protection_param"

  # using contains()
  validation {
    condition     = contains(["yes", "no"], var.activate_reputation_lists_protection_param)
    error_message = "Invalid input, options: \"yes\",\"no\"."
  }
}

variable "activate_bad_bot_protection_param" {
  type        = string
  default     = "yes"
  description = "activate_bad_bot_protection_param"
  # using contains()
  validation {
    condition     = contains(["yes", "no"], var.activate_bad_bot_protection_param)
    error_message = "Invalid input, options: \"yes\",\"no\"."
  }
}

variable "request_threshold_by_country_param" {
  type        = string
  description = "request_threshold_by_country_param"
  default     = "no"
}

variable "http_flood_athena_query_group_by_param" {
  type        = string
  default     = "None"
  description = "http_flood_athena_query_group_by_param"
  validation {
    condition     = contains(["Country", "URI", "Country and URI", "None"], var.http_flood_athena_query_group_by_param)
    error_message = "Invalid input, options: \"Country\", \"Country and URI\",\"None\"."
  }
}

variable "athena_query_run_time_schedule_param" {
  type        = number
  description = "athena_query_run_time_schedule_param"
  default     = 4
  validation {
    condition     = var.athena_query_run_time_schedule_param > 1
    error_message = "AthenaQueryRunTimeScheduleParam min value should be 1"
  }
}


variable "activate_scanners_probes_protection_param" {
  type        = string
  description = "activate_scanners_probes_protection_param"
  default     = "yes - Amazon Athena log parser"

  # using contains()
  validation {
    condition     = contains(["yes - AWS Lambda log parser", "yes - Amazon Athena log parser", "no"], var.activate_scanners_probes_protection_param)
    error_message = "Invalid input, options: \"yes - AWS Lambda log parser\", \"yes - Amazon Athena log parser\",\"no\"."
  }
}

variable "scanners_probes_protection_activated" {
  type        = string
  default     = "yes"
  description = "scanners_probes_protection_activated"
}

variable "bad_bot_protection_activated" {
  type        = string
  default     = "yes"
  description = "bad_bot_protection_activated"
  validation {
    condition     = contains(["yes", "no"], var.bad_bot_protection_activated)
    error_message = "Invalid input, options: \"yes\",\"no\"."
  }
}

variable "api_stage" {
  description = "api stage"
  type        = string
  default     = "ProdStage"
}

variable "reputation_lists_protection_activated" {
  type        = string
  default     = "yes"
  description = "reputation_lists_protection_activated"
  validation {
    condition     = contains(["yes", "no"], var.reputation_lists_protection_activated)
    error_message = "Invalid input, options: \"yes\",\"no\"."
  }
}

variable "ip_retention_period" {
  type        = string
  default     = "yes"
  description = "ip_retention_period"
  validation {
    condition     = contains(["yes", "no"], var.ip_retention_period)
    error_message = "Invalid input, options: \"yes\",\"no\"."
  }
}

variable "resolve_count" {
  type        = string
  description = "resolve_count"
  default     = "yes"
}

variable "aws_managed_crs_activated" {
  type        = bool
  description = "aws_managed_crs_activated"
}

variable "aws_managed_ap_activated" {
  type        = bool
  description = "aws_managed_ap_activated"
}

variable "aws_managed_kbi_activated" {
  type        = bool
  description = "aws_managed_kbi_activated"
}

variable "aws_managed_ipr_activated" {
  type        = bool
  description = "aws_managed_ipr_activated"
}

variable "aws_managed_api_activated" {
  type        = bool
  description = "aws_managed_ap_activated"
}

variable "aws_managed_sql_activated" {
  type        = bool
  description = "aws_managed_sql_activated"
}

variable "aws_managed_linux_activated" {
  type        = bool
  description = "aws_managed_linux_activated"
}

variable "aws_managed_posix_activated" {
  type        = bool
  description = "aws_managed_posix_activated"
}

variable "aws_managed_windows_activated" {
  type        = bool
  description = "aws_managed_windows_activated"
}

variable "aws_managed_php_activated" {
  type        = bool
  description = "aws_managed_php_activated"
}

variable "aws_managed_wp_activated" {
  type        = bool
  description = "aws_managed_wp_activated"
}

variable "sql_injection_protection_activated" {
  type        = bool
  description = "sql_injection_protection_activated"
}

variable "cross_site_scripting_protection_activated" {
  type        = bool
  description = "cross_site_scripting_protection_activated"
}

variable "create_access_logging_bucket" {
  type        = string
  description = "create_access_logging_bucket"
  default     = "no"
}

variable "app_access_log_bucket_logging_enabled" {
  type        = string
  description = "app_access_log_bucket_logging_enabled"
  default     = "no"
}

variable "user_defined_app_access_log_bucket_prefix" {
  type        = string
  description = "user_defined_app_access_log_bucket_prefix"
  default     = "AWSLogs"
}

variable "access_logging_bucket_name" {
  type        = string
  description = "access_logging_bucket_name"
  default     = null
}

variable "retention_in_days" {
  type        = number
  description = "retention_in_days"
  default     = 365
  validation {
    condition     = contains([-1, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 2192, 2557, 2922, 3288, 3653], var.retention_in_days)
    error_message = "Invalid input, options:-1,1,3,5,7,14,30,60,90,120,150,180,365,400,545,731,1827,2192,2557,2922,3288,3653"
  }
}