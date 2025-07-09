#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

##check

resource "random_uuid" "test" {
}

resource "random_id" "server" {
  byte_length = 8
}

module "waf_key" {
  source              = "../../modules/kms"
  description         = "KMS key 1"
  enable_key_rotation = true
}

module "ip_sets" {
  source                                = "../../modules/waf"
  create_ipset                          = true
  SCOPE                                 = local.scope
  BadBotProtectionActivated             = var.bad_bot_protection_activated
  ReputationListsProtectionActivated    = var.reputation_lists_protection_activated
  ScannersProbesProtectionActivated     = var.scanners_probes_protection_activated
  AWSManagedCRSActivated                = var.aws_managed_crs_activated
  AWSManagedAPActivated                 = var.aws_managed_ap_activated
  AWSManagedKBIActivated                = var.aws_managed_kbi_activated
  AWSManagedIPRActivated                = var.aws_managed_ipr_activated
  AWSManagedAIPActivated                = var.aws_managed_api_activated
  AWSManagedSQLActivated                = var.aws_managed_sql_activated
  AWSManagedLinuxActivated              = var.aws_managed_linux_activated
  AWSManagedPOSIXActivated              = var.aws_managed_posix_activated
  AWSManagedWindowsActivated            = var.aws_managed_windows_activated
  AWSManagedPHPActivated                = var.aws_managed_php_activated
  AWSManagedWPActivated                 = var.aws_managed_wp_activated
  SqlInjectionProtectionActivated       = var.sql_injection_protection_activated
  CrossSiteScriptingProtectionActivated = var.cross_site_scripting_protection_activated
}

module "s3_waf_log_bucket" {
  count         = local.http_flood_protection_log_parser_activated == "yes" ? 1 : 0
  source        = "../../modules/s3"
  rolename      = module.s3_iam_role.role_name
  bucket        = "${random_id.server.hex}-waflogbucket"
  acl           = "private"
  force_destroy = true
  versioning = {
    enabled = true
  }
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = var.sse_algorithm
      }
    }
  }
}

module "s3_access_logging_bucket" {
  count         = var.create_access_logging_bucket == "yes" ? 1 : 0
  source        = "../../modules/s3"
  rolename      = module.s3_iam_role.role_name
  bucket        = "${random_id.server.hex}-accesslogbucket"
  acl           = "log-delivery-write"
  force_destroy = true
  versioning = {
    enabled = true
  }
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = var.sse_algorithm
      }
    }
  }
}

module "s3_app_log_bucket" {
  count         = var.resolve_count == "yes" ? 1 : 0
  source        = "../../modules/s3"
  rolename      = module.s3_iam_role.role_name
  bucket        = "${random_id.server.hex}-applogbucket"
  acl           = "private"
  force_destroy = true
  versioning = {
    enabled = true
  }
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = var.sse_algorithm
      }
    }
  }
  logging = var.app_access_log_bucket_logging_enabled == "no" ? {} : {
    target_bucket = local.target_bucket
    target_prefix = "${var.user_defined_app_access_log_bucket_prefix}/"
  }
}



#check
module "s3_iam_role" {
  source              = "../../modules/iam"
  role_name           = "s3_bucket_role_${random_id.server.hex}"
  policy_name         = "s3_bucket_policy_${random_id.server.hex}"
  assume_role_actions = ["sts:AssumeRole"]
  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  ]

  policy_statements = [
    {
      sid       = "AmazoncustomS3ReadOnlyAccess"
      effect    = "Allow"
      actions   = ["s3:Get*", "s3:List*", "s3-object-lambda:Get*", "s3-object-lambda:List*"]
      resources = ["*"]
    }
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# WAF Resource
# ----------------------------------------------------------------------------------------------------------------------

module "ip_retention_resource" {
  source                 = "../../modules/ip_retention_resource"
  random_id              = random_id.server.hex
  kms_key_arn            = module.waf_key.kms_arn
  IPRetentionPeriod      = var.ip_retention_period
  USER_AGENT_EXTRA       = "${var.user_agent_extra}/${var.source_version}/${random_id.server.hex}/Terraform"
  KeyPrefix              = "${var.key_prefix}/${var.source_version}"
  WAFWhitelistSetV4_name = module.ip_sets.WAFWhitelistSetV4_name
  WAFBlacklistSetV4_name = module.ip_sets.WAFBlacklistSetV4_name
  WAFWhitelistSetV6_name = module.ip_sets.WAFWhitelistSetV6_name
  WAFBlacklistSetV6_name = module.ip_sets.WAFBlacklistSetV6_name
  WAFWhitelistSetV4_arn  = module.ip_sets.WAFWhitelistSetV4_arn
  WAFBlacklistSetV4_arn  = module.ip_sets.WAFBlacklistSetV4_arn
  WAFWhitelistSetV6_arn  = module.ip_sets.WAFWhitelistSetV6_arn
  WAFBlacklistSetV6_arn  = module.ip_sets.WAFBlacklistSetV6_arn
  retention_in_days      = var.retention_in_days
}

module "firehouse_athena_source" {
  count                                   = var.resolve_count == "yes" ? 1 : 0
  source                                  = "../../modules/firehose_athena_source"
  random_id                               = random_id.server.hex
  kms_key_arn                             = module.waf_key.kms_arn
  AthenaLogParser                         = local.athena_log_parser
  USER_AGENT_EXTRA                        = "${var.user_agent_extra}/${var.source_version}/${random_id.server.hex}/Terraform"
  KeyPrefix                               = "${var.key_prefix}/${var.source_version}"
  HttpFloodAthenaLogParser                = local.http_flood_athena_log_parser
  AppLogBucket                            = module.s3_app_log_bucket[0].bucket_name
  ScannersProbesAthenaLogParser           = local.scanners_probes_athena_log_parser
  s3_waf_log_bucket_name                  = try(module.s3_waf_log_bucket[0].bucket_name, "")
  s3_waf_log_bucket_arn                   = try(module.s3_waf_log_bucket[0].bucket_arn, "")
  ALBScannersProbesAthenaLogParser        = local.alb_scanners_probes_athena_log_parser
  HttpFloodProtectionLogParserActivated   = local.http_flood_protection_log_parser_activated
  CloudFrontScannersProbesAthenaLogParser = local.cloud_front_scanners_probes_athena_log_parser
  access_log_bucket                       = module.s3_app_log_bucket[0].bucket_name
  retention_in_days                       = var.retention_in_days
}

module "waf_resource" {
  count                                          = var.resolve_count == "yes" ? 1 : 0
  source                                         = "../../modules/waf_resource"
  random_id                                      = random_id.server.hex
  kms_key_arn                                    = module.waf_key.kms_arn
  s3_iam_role                                    = module.s3_iam_role.role_name
  LogParser                                      = local.log_parser
  api_stage                                      = var.api_stage
  USER_AGENT_EXTRA                               = "${var.user_agent_extra}/${var.source_version}/${random_id.server.hex}/Terraform"
  KeyPrefix                                      = "${var.key_prefix}/${var.source_version}"
  WAFWhitelistSetV4_arn                          = module.ip_sets.WAFWhitelistSetV4_arn
  WAFWhitelistSetV6_arn                          = module.ip_sets.WAFWhitelistSetV6_arn
  WAFBlacklistSetV4_arn                          = module.ip_sets.WAFBlacklistSetV4_arn
  WAFBlacklistSetV6_arn                          = module.ip_sets.WAFBlacklistSetV6_arn
  RequestThreshold                               = var.request_threshold
  WAFScannersProbesSetV4_arn                     = module.ip_sets.WAFScannersProbesSetV4_arn
  WAFScannersProbesSetV6_arn                     = module.ip_sets.WAFScannersProbesSetV6_arn
  WAFReputationListsSetV4_arn                    = module.ip_sets.WAFReputationListsSetV4_arn
  WAFReputationListsSetV6_arn                    = module.ip_sets.WAFReputationListsSetV6_arn
  WAFReputationListsSetV4_name                   = module.ip_sets.WAFReputationListsSetV4_name
  WAFReputationListsSetV6_name                   = module.ip_sets.WAFReputationListsSetV6_name
  WAFBadBotSetV4_arn                             = module.ip_sets.WAFBadBotSetV4_arn
  WAFBadBotSetV6_arn                             = module.ip_sets.WAFBadBotSetV6_arn
  WAFBadBotSetV4_name                            = module.ip_sets.WAFBadBotSetV4_name
  WAFBadBotSetV6_name                            = module.ip_sets.WAFBadBotSetV6_name
  WAFHttpFloodSetIPV4arn                         = local.waf_http_flood_set_ipv4_arn
  WAFHttpFloodSetIPV6arn                         = local.waf_http_flood_set_ipv6_arn
  SCOPE                                          = local.scope
  HttpFloodProtectionLogParserActivated          = local.http_flood_protection_log_parser_activated
  AppLogBucket                                   = module.s3_app_log_bucket[0].bucket_name
  BadBotProtectionActivated                      = var.bad_bot_protection_activated
  LOG_TYPE                                       = local.log_type
  ScannersProbesAthenaLogParser                  = local.scanners_probes_athena_log_parser
  ENDPOINT                                       = var.end_point
  ReputationListsProtectionActivated             = var.reputation_lists_protection_activated
  WafLogBucket                                   = local.waf_log_bucket
  WAFScannersProbesSetV4_name                    = module.ip_sets.WAFScannersProbesSetV4_name
  WAFScannersProbesSetV6_name                    = module.ip_sets.WAFScannersProbesSetV6_name
  WAFHttpFloodSetIPV4Name                        = local.waf_http_flood_set_ipv4_name
  WAFHttpFloodSetIPV6Name                        = local.waf_http_flood_set_ipv6_name
  HttpFloodAthenaLogParser                       = local.http_flood_athena_log_parser
  IPRetentionPeriod                              = var.ip_retention_period
  s3_waf_log_bucket_name                         = try(module.s3_waf_log_bucket[0].bucket_name, "")
  remove_expired_ip_iam_role                     = module.ip_retention_resource.remove_expired_role_arn
  glue_database_name                             = module.firehouse_athena_source[count.index].glue_database_name
  waf_access_logs_table_name                     = module.firehouse_athena_source[count.index].waf_access_logs_table_name
  waf_app_access_log_athena_query_workgroup_name = module.firehouse_athena_source[count.index].waf_app_access_log_athena_query_workgroup_name
  AppAccessLogsTable                             = local.app_access_logs_table
  firehouse_arn                                  = module.firehouse_athena_source[0].firehouse_arn
  RequestThresholdByCountryParam                 = var.request_threshold_by_country_param
  HTTPFloodAthenaQueryGroupByParam               = var.http_flood_athena_query_group_by_param
  AthenaQueryRunTimeScheduleParam                = var.athena_query_run_time_schedule_param
  AWSManagedCRSActivated                         = var.aws_managed_crs_activated
  AWSManagedAPActivated                          = var.aws_managed_ap_activated
  AWSManagedKBIActivated                         = var.aws_managed_kbi_activated
  AWSManagedIPRActivated                         = var.aws_managed_ipr_activated
  AWSManagedAIPActivated                         = var.aws_managed_api_activated
  AWSManagedSQLActivated                         = var.aws_managed_sql_activated
  AWSManagedLinuxActivated                       = var.aws_managed_linux_activated
  AWSManagedPOSIXActivated                       = var.aws_managed_posix_activated
  AWSManagedWindowsActivated                     = var.aws_managed_windows_activated
  AWSManagedPHPActivated                         = var.aws_managed_php_activated
  AWSManagedWPActivated                          = var.aws_managed_wp_activated
  SqlInjectionProtectionActivated                = var.sql_injection_protection_activated
  CrossSiteScriptingProtectionActivated          = var.cross_site_scripting_protection_activated
  retention_in_days                              = var.retention_in_days
}

module "s3_waf_log_bucket_notification" {
  count               = local.http_flood_protection_log_parser_activated == "yes" ? 1 : 0
  source              = "../../modules/s3_notification"
  create_notification = true
  bucket              = module.s3_waf_log_bucket[0].bucket_id
  lambda_notifications = {
    lambda1 = {
      id            = "Call s3 log partition function"
      function_arn  = module.waf_resource[0].log_parser_lambda_arn
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = "athena_results/"
      filter_suffix = "csv"
    }
  }
  depends_on = [
    module.waf_resource,
    module.firehouse_athena_source,
    module.ip_retention_resource
  ]
}

module "s3_app_log_bucket_notification_1" {
  count               = var.resolve_count == "yes" ? 1 : 0
  source              = "../../modules/s3_notification"
  create_notification = true
  bucket              = module.s3_app_log_bucket[0].bucket_id
  lambda_notifications = {
    lambda1 = {
      id            = "Call Athena Result Parser"
      function_arn  = module.waf_resource[0].moves3logsforpartition_lambda_arn
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = "AWSLogs/"
      filter_suffix = "gz"
    }
  }
  depends_on = [
    module.waf_resource,
    module.firehouse_athena_source,
    module.ip_retention_resource
  ]
}

module "s3_app_log_bucket_notification" {
  count               = var.resolve_count == "yes" ? 1 : 0
  source              = "../../modules/s3_notification"
  create_notification = true
  bucket              = module.s3_app_log_bucket[0].bucket_id
  lambda_notifications = {
    lambda1 = {
      id            = "Call s3 log partition function"
      function_arn  = module.waf_resource[0].log_parser_lambda_arn
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = "athena_results/"
      filter_suffix = "csv"
    }
  }
  depends_on = [
    module.waf_resource,
    module.firehouse_athena_source,
    module.ip_retention_resource
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Custom Resources
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_cloudformation_stack" "trigger_codebuild_stack" {
  #checkov:skip=CKV_AWS_124: "Ensure that CloudFormation stacks are sending event notifications to an SNS topic"
  count = var.resolve_count == "yes" ? 1 : 0
  name  = "custom-resources-stack-${random_id.server.hex}"
  parameters = {
    HttpFloodProtectionRateBasedRuleActivated = local.http_flood_protection_rate_based_rule_activated
    HttpFloodProtectionLogParserActivated     = local.http_flood_protection_log_parser_activated
    RandomId                                  = random_id.server.hex
    RequestThresholdByCountryParam            = var.request_threshold_by_country_param
    HTTPFloodAthenaQueryGroupByParam          = var.http_flood_athena_query_group_by_param
    AthenaQueryRunTimeScheduleParam           = var.athena_query_run_time_schedule_param
    AppAccessLogBucket                        = module.s3_app_log_bucket[0].bucket_name
    Region                                    = data.aws_region.current.name
    RequestThreshold                          = var.request_threshold
    ReputationListsProtectionActivated        = var.reputation_lists_protection_activated
    CustomResourcearn                         = module.waf_resource[count.index].custom_resource_lambda_arn
    ScannersProbesLambdaLogParser             = local.scanners_probes_lambda_log_parser
    ScannersProbesProtectionActivated         = var.scanners_probes_protection_activated
    BadBotProtectionActivated                 = var.bad_bot_protection_activated
    HttpFloodLambdaLogParser                  = local.http_flood_lambda_log_parser
    ScannersProbesLambdaLogParser             = local.scanners_probes_lambda_log_parser
    WafLogBucket                              = local.waf_log_bucket
    WAFBlockPeriod                            = var.waf_block_period
    ActivateSqlInjectionProtectionParam       = var.activate_sql_injection_protection_param
    ActivateCrossSiteScriptingProtectionParam = var.activate_cross_site_scripting_protection_param
    ActivateHttpFloodProtectionParam          = var.activate_http_flood_protection_param
    ActivateScannersProbesProtectionParam     = var.activate_scanners_probes_protection_param
    ActivateReputationListsProtectionParam    = var.activate_reputation_lists_protection_param
    ActivateBadBotProtectionParam             = var.activate_bad_bot_protection_param
    ActivateAWSManagedRulesParam              = var.activate_aws_managed_rules_param
    KeepDataInOriginalS3Location              = var.keep_original_data
    IPRetentionPeriodAllowedParam             = var.ip_retention_period_allowed_param
    IPRetentionPeriodDeniedParam              = var.ip_retention_period_denied_param
    SendAnonymousUsageData                    = var.send_anonymous_usage_data
    SNSEmailParam                             = var.sns_email_param
    version                                   = var.source_version
    ErrorThreshold                            = var.error_threshold
    WAFWhitelistSetIPV4                       = module.ip_sets.WAFWhitelistSetV4_id
    WAFBlacklistSetIPV4                       = module.ip_sets.WAFBlacklistSetV4_id
    WAFHttpFloodSetIPV4                       = local.waf_http_flood_set_ipv4
    WAFScannersProbesSetIPV4                  = local.waf_scanners_probes_set_ipv4
    WAFReputationListsSetIPV4                 = local.waf_reputation_lists_set_ipv4
    WAFBadBotSetIPV4                          = local.waf_bad_bot_set_ipv4
    WAFWhitelistSetIPV6                       = module.ip_sets.WAFWhitelistSetV6_id
    WAFBlacklistSetIPV6                       = module.ip_sets.WAFBlacklistSetV6_id
    WAFHttpFloodSetIPV6                       = local.waf_http_flood_set_ipv6
    WAFScannersProbesSetIPV6                  = local.waf_scanners_probes_set_ipv6
    WAFReputationListsSetIPV6                 = local.waf_reputation_lists_set_ipv6
    WAFBadBotSetIPV6                          = local.waf_bad_bot_set_ipv6
    WAFWhitelistSetIPV4Name                   = module.ip_sets.WAFWhitelistSetV4_name
    WAFBlacklistSetIPV4Name                   = module.ip_sets.WAFBlacklistSetV4_name
    WAFHttpFloodSetIPV4Name                   = local.waf_http_flood_set_ipv4_name
    WAFScannersProbesSetIPV4Name              = local.waf_scanners_probes_set_ipv4_name
    WAFReputationListsSetIPV4Name             = local.waf_reputation_lists_set_ipv4_name
    WAFBadBotSetIPV4Name                      = local.waf_bad_bot_set_ipv4_name
    WAFWhitelistSetIPV6Name                   = module.ip_sets.WAFWhitelistSetV6_name
    WAFBlacklistSetIPV6Name                   = module.ip_sets.WAFBlacklistSetV6_name
    WAFHttpFloodSetIPV6Name                   = local.waf_http_flood_set_ipv6_name
    WAFScannersProbesSetIPV6Name              = local.waf_scanners_probes_set_ipv6_name
    WAFReputationListsSetIPV6Name             = local.waf_reputation_lists_set_ipv6_name
    WAFBadBotSetIPV6Name                      = local.waf_bad_bot_set_ipv6_name
    wafwebacl                                 = module.waf_resource[count.index].waf_acl_name
    ActivateAWSManagedAPParam                 = local.activate_aws_managed_apparam
    ActivateAWSManagedKBIParam                = local.activate_aws_managed_kbiparam
    ActivateAWSManagedIPRParam                = local.activate_aws_managed_ippparam
    ActivateAWSManagedAIPParam                = local.activate_aws_managed_aipparam
    ActivateAWSManagedSQLParam                = local.activate_aws_managed_sqlparam
    ActivateAWSManagedLinuxParam              = local.activate_aws_managed_linuxparam
    ActivateAWSManagedPOSIXParam              = local.activate_aws_managed_posixparam
    ActivateAWSManagedWindowsParam            = local.activate_aws_managed_windowsparam
    ActivateAWSManagedPHPParam                = local.activate_aws_managed_phpparam
    ActivateAWSManagedWPParam                 = local.activate_aws_managed_wpparam
    UserDefinedAppAccessLogBucketPrefixParam  = local.user_defined_app_access_log_bucket_prefix_param
    AppAccessLogBucketLoggingStatusParam      = local.app_access_log_bucket_logging_status_param
    HTTPFloodAthenaQueryGroupByParam          = var.http_flood_athena_query_group_by_param
  }

  template_body = file("../../templates/custom-resource.json")
}

module "dashboard" {
  source           = "../../modules/cloudwatch"
  create_dashboard = true
}