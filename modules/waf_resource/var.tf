locals {
  run_time = "python3.9"
}

variable "random_id" {
  description = "random_id"
}

variable "AppAccessLogBucket" {
  description = "Application Access Log Bucket Name"
  type        = string
  default     = "myownbucket-tam"
}
variable "SourceBucket" {
  description = "Lambda source code bucket"
  type        = string
  default     = "solutions"
}
variable "KeyPrefix" {
  description = "Keyprefix values for the lambda source code"
  type        = string
  default     = "security-automations-for-aws-waf"
}
variable "LOG_LEVEL" {
  description = "Log level"
  type        = string
  default     = "INFO"
}

variable "SCOPE" {
  description = "SCOPE"
  type        = string
}

variable "USER_AGENT_EXTRA" {
  description = "UserAgent"
  type        = string
  default     = "AwsSolution/SO0006-tf/v4.0.2"
}
variable "SEND_ANONYMOUS_USAGE_DATA" {
  description = "Data collection parameter"
  type        = string
  default     = "yes"
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
variable "KEEP_ORIGINAL_DATA" {
  description = "S3 original data"
  type        = string
  default     = "No"
}
variable "SendAnonymousUsageData" {
  description = "Data collection parameter"
  type        = string
  default     = "yes"
}

variable "sse_algorithm" {
  description = "sse_algorithm"
  type        = string
  default     = "aws:kms"
}

variable "s3_iam_role" {
  description = "s3 role"
  type        = string
}

variable "LogParser" {
  type    = string
  default = "no"
}

variable "HttpFloodAthenaLogParser" {
  type    = string
  default = "no"
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

variable "WAFScannersProbesSetV4_arn" {
  description = "WAFScannersProbesSetV4 arn"
  type        = string
}
variable "WAFScannersProbesSetV6_arn" {
  description = "WAFScannersProbesSetV6 arn"
  type        = string
}

variable "WAFScannersProbesSetV4_name" {
  description = "WAFScannersProbesSetV4 name"
  type        = string
}
variable "WAFScannersProbesSetV6_name" {
  description = "WAFScannersProbesSetV6 name"
  type        = string
}

variable "WAFReputationListsSetV4_arn" {
  description = "WAFReputationListsSetV4 arn"
  type        = string
}
variable "WAFReputationListsSetV6_arn" {
  description = "WAFReputationListsSetV6 arn"
  type        = string
}

variable "WAFReputationListsSetV4_name" {
  description = "WAFReputationListsSetV4 name"
  type        = string
}
variable "WAFReputationListsSetV6_name" {
  description = "WAFReputationListsSetV6 name"
  type        = string
}

variable "WAFHttpFloodSetIPV4arn" {
  description = "WAFHttpFloodSetIPV4 arn"
  type        = string
}
variable "WAFHttpFloodSetIPV6arn" {
  description = "WAFHttpFloodSetIPV6 arn"
  type        = string
}

variable "RequestThreshold" {
  description = "RequestThreshold"
  type        = string
}

variable "RequestThresholdByCountryParam" {
  description = "RequestThresholdByCountryParam"
  type        = string
}

variable "HTTPFloodAthenaQueryGroupByParam" {
  description = "HTTPFloodAthenaQueryGroupByParam"
  type        = string
}

variable "AthenaQueryRunTimeScheduleParam" {
  description = "AthenaQueryRunTimeScheduleParam"
  type        = string
}
variable "WAFBadBotSetV4_arn" {
  description = "WAFBadBotSetV4_arn"
  type        = string
}
variable "WAFBadBotSetV6_arn" {
  description = "WAFBadBotSetV6_arn"
  type        = string
}

variable "resolve_count" {
  type    = string
  default = "yes"
}

variable "AppLogBucket" {
  description = "App log bucket"
  type        = string
}

variable "BadBotProtectionActivated" {
  type    = string
  default = "no"
}

variable "api_stage" {
  description = "api stage"
  type        = string
  default     = null
}

variable "ScannersProbesAthenaLogParser" {
  type    = string
  default = "no"
}

variable "ENDPOINT" {
  type = string
}

variable "kms_key_arn" {
  description = "ARN value of KMS KEY"
  type        = string
}

variable "WAFBadBotSetV6_name" {
  description = "WAFBadBotSetV6 name"
  type        = string
}

variable "WAFBadBotSetV4_name" {
  description = "WAFBadBotSetV4 name"
  type        = string
}

variable "LOG_TYPE" {
  description = "LOG_TYPE"
  type        = string
}

variable "ReputationListsProtectionActivated" {
  type    = string
  default = "no"
}

variable "WafLogBucket" {
  description = "WafLogBucket"
  type        = string
}

variable "WAFBlockPeriod" {
  description = "block period for Log Monitoring Settings"
  type        = number
  default     = 240
}
variable "ErrorThreshold" {
  description = "error threshold for Log Monitoring Settings"
  type        = number
  default     = 50
}

variable "WAFHttpFloodSetIPV4Name" {
  description = "WAFHttpFloodSetIPV4Name"
  type        = string
}

variable "WAFHttpFloodSetIPV6Name" {
  description = "WAFHttpFloodSetIPV6Name"
  type        = string
}

variable "IPRetentionPeriod" {
  type    = string
  default = "no"
}

variable "s3_waf_log_bucket_name" {
  description = "waf log bucket"
  type        = string
}

variable "remove_expired_ip_iam_role" {
  description = "IAM role"
  type        = string
}

variable "glue_database_name" {
  description = "glue_database_name"
  type        = string
}

variable "waf_access_logs_table_name" {
  description = "waf_access_logs_table_name"
  type        = string
}

variable "waf_app_access_log_athena_query_workgroup_name" {
  description = "waf_app_access_log_athena_query_workgroup_name"
  type        = string
}

variable "AppAccessLogsTable" {
  description = "Application access logs table"
  type        = string
}

variable "firehouse_arn" {
  description = "firehouse_arn"
  type        = string
}

variable "HttpFloodProtectionLogParserActivated" {
  type    = string
  default = "no"
}

variable "AWSManagedCRSActivated" {
  type = bool
}

variable "AWSManagedAPActivated" {
  type = bool
}

variable "AWSManagedKBIActivated" {
  type = bool
}

variable "AWSManagedIPRActivated" {
  type = bool
}

variable "AWSManagedAIPActivated" {
  type = bool
}

variable "AWSManagedSQLActivated" {
  type = bool
}

variable "AWSManagedLinuxActivated" {
  type = bool
}

variable "AWSManagedPOSIXActivated" {
  type = bool
}

variable "AWSManagedWindowsActivated" {
  type = bool
}

variable "AWSManagedPHPActivated" {
  type = bool
}

variable "AWSManagedWPActivated" {
  type = bool
}

variable "SqlInjectionProtectionActivated" {
  type = bool
}

variable "CrossSiteScriptingProtectionActivated" {
  type = bool
}

variable "retention_in_days" {
  type    = number
  default = 365
}

variable "source_version" {
  description = "source code version"
  type        = string
  default     = "v4.0.2"
}