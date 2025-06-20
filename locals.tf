locals {

  condition     = local.http_flood_protection_rate_based_rule_activated == "yes" && var.request_threshold < 100
  error_message = "The minimum rate-based rule rate limit per 5 minute period is 100. If need to use values below that, please select AWS Lambda or Amazon Athena log parser"
  validate_fet_code_chk = regex(
    "^${local.error_message}$",
    (!local.condition
      ? local.error_message
  : ""))

  condition_region     = local.http_flood_protection_log_parser_activated == "yes" && var.end_point == "cloudfront" && data.aws_region.current.name != "us-east-1"
  error_message_region = "If you are capturing AWS WAF logs for a Amazon CloudFront distribution, create the stack in US East N Virginia"
  validate_fe_code_chk = regex(
    "^${local.error_message_region}$",
    (!local.condition_region
      ? local.error_message_region
  : ""))

  http_flood_protection_rate_based_rule_activated = var.activate_http_flood_protection_param == "yes - AWS WAF rate based rule" ? "yes" : "no"
  log_type                                        = var.end_point == "ALB" ? "alb" : "cloudFront"
  target_bucket                                   = var.create_access_logging_bucket == "yes" ? module.s3_access_logging_bucket[0].bucket_name : var.access_logging_bucket_name
  scope                                           = var.end_point == "ALB" ? "REGIONAL" : "CLOUDFRONT"
  scanners_probes_athena_log_parser               = var.activate_scanners_probes_protection_param == "yes - Amazon Athena log parser" ? "yes" : "no"
  scanners_probes_lambda_log_parser               = var.activate_scanners_probes_protection_param == "yes - AWS Lambda log parser" ? "yes" : "no"
  http_flood_athena_log_parser                    = var.activate_http_flood_protection_param == "yes - Amazon Athena log parser" ? "yes" : "no"
  http_flood_lambda_log_parser                    = var.activate_http_flood_protection_param == "yes - AWS Lambda log parser" ? "yes" : "no"
  http_flood_protection_log_parser_activated      = var.activate_http_flood_protection_param == "yes - AWS Lambda log parser" || var.activate_http_flood_protection_param == "yes - Amazon Athena log parser" ? "yes" : "no"
  athena_log_parser                               = var.activate_http_flood_protection_param == "yes - Amazon Athena log parser" || var.activate_scanners_probes_protection_param == "yes - Amazon Athena log parser" ? "yes" : "no"
  log_parser                                      = var.activate_http_flood_protection_param != "" && var.activate_scanners_probes_protection_param != "" ? "yes" : "no"
  alb_scanners_probes_athena_log_parser           = var.activate_scanners_probes_protection_param == "yes - Amazon Athena log parser" && var.end_point == "ALB" ? "yes" : "no"
  cloud_front_scanners_probes_athena_log_parser   = var.activate_scanners_probes_protection_param == "yes - Amazon Athena log parser" && var.end_point == "cloudfront" ? "yes" : "no"
  waf_http_flood_set_ipv4                         = length(module.ip_sets) != 0 ? "${module.ip_sets.WAFHttpFloodSetV4_id}" : "0"
  waf_scanners_probes_set_ipv4                    = length(module.ip_sets) != 0 && var.scanners_probes_protection_activated == "yes" ? "${module.ip_sets.WAFScannersProbesSetV4_id}" : "0"
  waf_reputation_lists_set_ipv4                   = length(module.ip_sets) != 0 && var.reputation_lists_protection_activated == "yes" ? "${module.ip_sets.WAFReputationListsSetV4_id}" : "0"
  waf_bad_bot_set_ipv4                            = length(module.ip_sets) != 0 && var.bad_bot_protection_activated == "yes" ? "${module.ip_sets.WAFBadBotSetV4_id}" : "0"
  waf_http_flood_set_ipv6                         = length(module.ip_sets) != 0 ? "${module.ip_sets.WAFHttpFloodSetV4_id}" : "0"
  waf_scanners_probes_set_ipv6                    = length(module.ip_sets) != 0 && var.scanners_probes_protection_activated == "yes" ? "${module.ip_sets.WAFScannersProbesSetV6_id}" : "0"
  waf_reputation_lists_set_ipv6                   = length(module.ip_sets) != 0 && var.reputation_lists_protection_activated == "yes" ? "${module.ip_sets.WAFReputationListsSetV6_id}" : "0"
  waf_bad_bot_set_ipv6                            = length(module.ip_sets) != 0 && var.bad_bot_protection_activated == "yes" ? "${module.ip_sets.WAFBadBotSetV6_id}" : "0"
  waf_http_flood_set_ipv4_name                    = length(module.ip_sets) != 0 ? "${module.ip_sets.WAFHttpFloodSetV4_name}" : "0"
  waf_scanners_probes_set_ipv4_name               = length(module.ip_sets) != 0 && var.scanners_probes_protection_activated == "yes" ? "${module.ip_sets.WAFScannersProbesSetV4_name}" : "0"
  waf_reputation_lists_set_ipv4_name              = length(module.ip_sets) != 0 && var.reputation_lists_protection_activated == "yes" ? "${module.ip_sets.WAFReputationListsSetV4_name}" : "0"
  waf_bad_bot_set_ipv4_name                       = length(module.ip_sets) != 0 && var.bad_bot_protection_activated == "yes" ? "${module.ip_sets.WAFBadBotSetV4_name}" : "0"
  waf_http_flood_set_ipv6_name                    = length(module.ip_sets) != 0 ? "${module.ip_sets.WAFHttpFloodSetV6_name}" : "0"
  waf_scanners_probes_set_ipv6_name               = length(module.ip_sets) != 0 && var.scanners_probes_protection_activated == "yes" ? "${module.ip_sets.WAFScannersProbesSetV6_name}" : "0"
  waf_reputation_lists_set_ipv6_name              = length(module.ip_sets) != 0 && var.reputation_lists_protection_activated == "yes" ? "${module.ip_sets.WAFReputationListsSetV6_name}" : "0"
  waf_bad_bot_set_ipv6_name                       = length(module.ip_sets) != 0 && var.bad_bot_protection_activated == "yes" ? "${module.ip_sets.WAFBadBotSetV6_name}" : "0"
  add_athena_partitions_lambda_arn                = length(module.firehouse_athena_source[0].add_athena_partitions_lambda_arn) != 0 ? "${module.firehouse_athena_source[0].add_athena_partitions_lambda_arn}" : "0"
  waf_http_flood_set_ipv4_arn                     = length(module.ip_sets) != 0 ? "${module.ip_sets.WAFHttpFloodSetV4_arn}" : "0"
  waf_http_flood_set_ipv6_arn                     = length(module.ip_sets) != 0 ? "${module.ip_sets.WAFHttpFloodSetV6_arn}" : "0"
  app_access_logs_table                           = (local.cloud_front_scanners_probes_athena_log_parser == "yes" ? "${module.firehouse_athena_source[0].cloudfront_glue_app_access_logs_table_name}" : (local.alb_scanners_probes_athena_log_parser == "yes" ? "${module.firehouse_athena_source[0].alb_glue_app_access_logs_table_name}" : "0"))
  glue_waf_access_logs_table                      = length(module.firehouse_athena_source[0].waf_access_logs_table_name) != 0 ? "${module.firehouse_athena_source[0].waf_access_logs_table_name}" : "0"
  waf_log_bucket                                  = length(module.s3_waf_log_bucket) != 0 ? "${module.s3_waf_log_bucket[0].bucket_name}" : "0"
  activate_aws_managed_apparam                    = var.aws_managed_ap_activated == true ? "yes" : "no"
  activate_aws_managed_kbiparam                   = var.aws_managed_kbi_activated == true ? "yes" : "no"
  activate_aws_managed_ippparam                   = var.aws_managed_ipr_activated == true ? "yes" : "no"
  activate_aws_managed_aipparam                   = var.aws_managed_api_activated == true ? "yes" : "no"
  activate_aws_managed_sqlparam                   = var.aws_managed_sql_activated == true ? "yes" : "no"
  activate_aws_managed_linuxparam                 = var.aws_managed_linux_activated == true ? "yes" : "no"
  activate_aws_managed_posixparam                 = var.aws_managed_posix_activated == true ? "yes" : "no"
  activate_aws_managed_windowsparam               = var.aws_managed_windows_activated == true ? "yes" : "no"
  activate_aws_managed_phpparam                   = var.aws_managed_php_activated == true ? "yes" : "no"
  activate_aws_managed_wpparam                    = var.aws_managed_wp_activated == true ? "yes" : "no"
  user_defined_app_access_log_bucket_prefix_param = "no"
  app_access_log_bucket_logging_status_param      = "no"
}