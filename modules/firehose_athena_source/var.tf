locals {
  run_time = "python3.9"
}

variable "AthenaLogParser" {
  type    = string
  default = "no"
}

variable "access_log_bucket" {
  type = string
}

variable "HttpFloodAthenaLogParser" {
  type    = string
  default = "no"
}

variable "ScannersProbesAthenaLogParser" {
  type    = string
  default = "no"
}

variable "HttpFloodProtectionLogParserActivated" {
  type    = string
  default = "no"
}

variable "CloudFrontScannersProbesAthenaLogParser" {
  type    = string
  default = "no"
}

variable "ALBScannersProbesAthenaLogParser" {
  type    = string
  default = "no"
}

variable "AppLogBucket" {
  description = "App log bucket"
  type        = string
}

variable "s3_waf_log_bucket_name" {
  description = "waf log bucket"
  type        = string
}

variable "s3_waf_log_bucket_arn" {
  description = "waf log bucket"
  type        = string
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

variable "DeliveryStreamName" {
  description = "Name of the Delivery stream value"
  type        = string
  default     = "aws-waf-logs-stream"
  validation {
    condition     = length(var.DeliveryStreamName) <= 20 && substr(var.DeliveryStreamName, 0, 13) == "aws-waf-logs-" && can(regex("[A-Za-z0-9_-]", var.DeliveryStreamName))
    error_message = "DeliveryStreamName name must start with letter, only contain letters, numbers, dashes, or underscores and must be between 1 and 64 characters."
  }
}

variable "glue_catalog_database_name" {
  description = "Name of the Delivery stream value"
  type        = string
  default     = "glue_database_waf"
  validation {
    condition     = can(regex("[A-Za-z0-9_-]", var.glue_catalog_database_name))
    error_message = "DeliveryStreamName name must start with letter, only contain letters, numbers, dashes, or underscores and must be between 1 and 64 characters."
  }
}

variable "waf_access_logs_columns" {
  default = {
    timestamp                   = "bigint"
    formatversion               = "int"
    webaclid                    = "string"
    terminatingruleid           = "string"
    terminatingruletype         = "string"
    action                      = "string"
    httpsourcename              = "string"
    httpsourceid                = "string"
    rulegrouplist               = "array<string>"
    ratebasedrulelist           = "array<string>"
    nonterminatingmatchingrules = "array<string>"
    httprequest                 = "struct<clientip:string,country:string,headers:array<struct<name:string,value:string>>,uri:string,args:string,httpversion:string,httpmethod:string,requestid:string>"
  }
}

variable "app_access_logs_columns" {
  default = {
    type                     = "string"
    time                     = "string"
    elb                      = "string"
    client_ip                = "string"
    client_port              = "int"
    target_ip                = "string"
    target_port              = "int"
    request_processing_time  = "double"
    response_processing_time = "double"
    target_processing_time   = "double"
    elb_status_code          = "string"
    target_status_code       = "string"
    received_bytes           = "bigint"
    sent_bytes               = "bigint"
    request_verb             = "string"
    request_url              = "string"
    request_proto            = "string"
    user_agent               = "string"
    ssl_cipher               = "string"
    ssl_protocol             = "string"
    target_group_arn         = "string"
    trace_id                 = "string"
    domain_name              = "string"
    chosen_cert_arn          = "string"
    matched_rule_priority    = "string"
    request_creation_time    = "string"
    actions_executed         = "string"
    redirect_url             = "string"
    lambda_error_reason      = "string"
    new_field                = "string"
  }
}

variable "cloudfront_app_access_logs_columns" {
  default = {
    date               = "date"
    time               = "string"
    location           = "string"
    bytes              = "bigint"
    requestip          = "string"
    method             = "string"
    host               = "string"
    uri                = "string"
    status             = "int"
    referrer           = "string"
    useragent          = "string"
    querystring        = "string"
    cookie             = "string"
    resulttype         = "string"
    requestid          = "string"
    hostheader         = "string"
    requestprotocol    = "string"
    requestbytes       = "bigint"
    timetaken          = "float"
    xforwardedfor      = "string"
    sslprotocol        = "string"
    sslcipher          = "string"
    responseresulttype = "string"
    httpversion        = "string"
    filestatus         = "string"
    encryptedfields    = "int"
  }
}

variable "retention_in_days" {
  type    = number
  default = 365
}
