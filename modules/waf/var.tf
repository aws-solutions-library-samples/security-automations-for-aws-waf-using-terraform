variable "create_waf_rule" {
  type    = string
  default = "false"
}

variable "create_ipset" {
  type    = string
  default = false
}

variable "WafAcl_name" {
  type        = string
  description = "Name of the WafAcl."
  default     = ""
}

variable "SCOPE" {
  type        = string
  default     = "REGIONAL"
  description = <<-DOC
    Specifies whether this is for an AWS CloudFront distribution or for a regional application.
    Possible values are `CLOUDFRONT` or `REGIONAL`.
  DOC
  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.SCOPE)
    error_message = "Allowed values: `CLOUDFRONT`, `REGIONAL`."
  }
}

variable "WhitelistSetV4_arn" {
  type    = string
  default = ""
}

variable "WhitelistSetV6_arn" {
  type    = string
  default = ""
}

variable "WAFBlacklistSetV4_arn" {
  type    = string
  default = ""
}

variable "WAFBlacklistSetV6_arn" {
  type    = string
  default = ""
}

variable "HttpFloodSetIPV4arn" {
  type    = string
  default = ""
}

variable "HttpFloodSetIPV6arn" {
  type    = string
  default = ""
}

variable "RequestThreshold" {
  type    = string
  default = ""
}

variable "WAFScannersProbesSetV4_arn" {
  type    = string
  default = ""
}

variable "WAFScannersProbesSetV6_arn" {
  type    = string
  default = ""
}

variable "WAFReputationListsSetV4_arn" {
  type    = string
  default = ""
}

variable "WAFReputationListsSetV6_arn" {
  type    = string
  default = ""
}

variable "WAFBadBotSetV4_arn" {
  type    = string
  default = ""
}

variable "WAFBadBotSetV6_arn" {
  type    = string
  default = ""
}

variable "BadBotProtectionActivated" {
  type    = string
  default = "no"
}

variable "ReputationListsProtectionActivated" {
  type    = string
  default = "no"
}

variable "ScannersProbesProtectionActivated" {
  type    = string
  default = "no"
}

variable "firehouse_arn" {
  description = "firehouse_arn"
  type        = string
  default     = null
}

variable "HttpFloodProtectionLogParserActivated" {
  type    = string
  default = "no"
}

variable "SqlInjectionProtectionActivated" {
  type = bool
}

variable "CrossSiteScriptingProtectionActivated" {
  type = bool
}

variable "HttpFloodProtectionRateBasedRuleActivated" {
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