data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# waf_resource

# ----------------------------------------------------------------------------------------------------------------------
#  WAFWebACL:
# ----------------------------------------------------------------------------------------------------------------------

module "waf_acl" {
  count                                 = var.resolve_count == "yes" ? 1 : 0
  source                                = "../waf"
  create_waf_rule                       = true
  WafAcl_name                           = "waf_web_acl_rules_${var.random_id}"
  HttpFloodProtectionLogParserActivated = var.HttpFloodProtectionLogParserActivated
  SCOPE                                 = var.SCOPE
  WhitelistSetV4_arn                    = var.WAFWhitelistSetV4_arn
  WhitelistSetV6_arn                    = var.WAFWhitelistSetV6_arn
  WAFBlacklistSetV4_arn                 = var.WAFBlacklistSetV4_arn
  WAFBlacklistSetV6_arn                 = var.WAFBlacklistSetV6_arn
  HttpFloodSetIPV4arn                   = var.WAFHttpFloodSetIPV4arn
  HttpFloodSetIPV6arn                   = var.WAFHttpFloodSetIPV6arn
  RequestThreshold                      = var.RequestThreshold
  WAFScannersProbesSetV4_arn            = var.WAFScannersProbesSetV4_arn
  WAFScannersProbesSetV6_arn            = var.WAFScannersProbesSetV6_arn
  WAFReputationListsSetV4_arn           = var.WAFReputationListsSetV4_arn
  WAFReputationListsSetV6_arn           = var.WAFReputationListsSetV6_arn
  WAFBadBotSetV4_arn                    = var.WAFBadBotSetV4_arn
  WAFBadBotSetV6_arn                    = var.WAFBadBotSetV6_arn
  firehouse_arn                         = var.firehouse_arn
  AWSManagedCRSActivated                = var.AWSManagedAPActivated
  AWSManagedAPActivated                 = var.AWSManagedAPActivated
  AWSManagedKBIActivated                = var.AWSManagedKBIActivated
  AWSManagedIPRActivated                = var.AWSManagedIPRActivated
  AWSManagedAIPActivated                = var.AWSManagedAIPActivated
  AWSManagedSQLActivated                = var.AWSManagedSQLActivated
  AWSManagedLinuxActivated              = var.AWSManagedLinuxActivated
  AWSManagedPOSIXActivated              = var.AWSManagedPOSIXActivated
  AWSManagedWindowsActivated            = var.AWSManagedWindowsActivated
  AWSManagedPHPActivated                = var.AWSManagedPHPActivated
  AWSManagedWPActivated                 = var.AWSManagedWPActivated
  SqlInjectionProtectionActivated       = var.SqlInjectionProtectionActivated
  CrossSiteScriptingProtectionActivated = var.CrossSiteScriptingProtectionActivated
}

# ----------------------------------------------------------------------------------------------------------------------
# Role Creation for Lambda functions
# ----------------------------------------------------------------------------------------------------------------------

#Role 1 - LambdaRoleHelper

module "helper_iam_role" {
  source              = "../iam"
  role_name           = "lambda_role_helper1_${var.random_id}"
  policy_name         = "lambda_policy_helper1_${var.random_id}"
  assume_role_actions = ["sts:AssumeRole"]
  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  ]

  policy_statements = [
    {
      sid       = "helperS3Access"
      effect    = "Allow"
      actions   = ["s3:GetBucketLocation", "s3:GetObject", "s3:ListBucket"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.AppLogBucket}"]
    },
    {
      sid       = "helperec2Access"
      effect    = "Allow"
      actions   = ["ec2:CreateNetworkInterface"]
      resources = ["arn:${data.aws_partition.current.partition}:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:/*"]
    },
    {
      sid       = "helpersqs"
      effect    = "Allow"
      actions   = ["sqs:SendMessage"]
      resources = ["arn:${data.aws_partition.current.partition}:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    },
    {
      sid       = "helperWAFAccess"
      effect    = "Allow"
      actions   = ["wafv2:ListWebACLs"]
      resources = ["arn:${data.aws_partition.current.partition}:wafv2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:regional/webacl/*", "arn:${data.aws_partition.current.partition}:wafv2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:global/webacl/*"]
    },
    {
      sid       = "helperLogsAccess"
      effect    = "Allow"
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*helper*"]
    }
  ]
}

#Role 2 - LambdaRoleBadBot

module "badbot_parser_iam_role" {
  count               = var.BadBotProtectionActivated == "yes" ? 1 : 0
  source              = "../iam"
  role_name           = "lambda_role_badbot1_${var.random_id}"
  policy_name         = "lambda_policy_badbot1_${var.random_id}"
  assume_role_actions = ["sts:AssumeRole"]
  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  ]

  policy_statements = [
    {
      sid       = "badbotec2Access"
      effect    = "Allow"
      actions   = ["ec2:CreateNetworkInterface"]
      resources = ["arn:${data.aws_partition.current.partition}:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:/*"]
    },
    {
      sid       = "badbotsqs"
      effect    = "Allow"
      actions   = ["sqs:SendMessage"]
      resources = ["arn:${data.aws_partition.current.partition}:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    },
    {
      sid       = "badbotsWAFAccess"
      effect    = "Allow"
      actions   = ["wafv2:GetIPSet", "wafv2:UpdateIPSet"]
      resources = ["${var.WAFBadBotSetV4_arn}", "${var.WAFBadBotSetV6_arn}"]
    },
    {
      sid       = "badbotLogsAccess"
      effect    = "Allow"
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*badbotparser*"]
    },
    {
      sid       = "badbotcloudwatchAccess"
      effect    = "Allow"
      actions   = ["cloudwatch:GetMetricStatistics"]
      resources = ["*"]
    }
  ]
}

#Role 3 - LambdaRolePartitionS3Logs

module "lambda_role_partition_iam_role" {
  count               = var.ScannersProbesAthenaLogParser == "yes" ? 1 : 0
  source              = "../iam"
  role_name           = "lambda_MoveS3LogsForPartition_${var.random_id}"
  policy_name         = "lambda_MoveS3LogsForPartition_badbot1_${var.random_id}"
  assume_role_actions = ["sts:AssumeRole"]
  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  ]

  policy_statements = [
    {
      sid       = "MoveS3LogsForPartitionec2Access"
      effect    = "Allow"
      actions   = ["ec2:CreateNetworkInterface"]
      resources = ["arn:${data.aws_partition.current.partition}:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:/*"]
    },
    {
      sid       = "MoveS3LogsForPartitionsqs"
      effect    = "Allow"
      actions   = ["sqs:SendMessage"]
      resources = ["arn:${data.aws_partition.current.partition}:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    },
    {
      sid       = "MoveS3LogsForPartitions3"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:DeleteObject", "s3:PutObject"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.AppLogBucket}/*"]
    },
    {
      sid       = "MoveS3LogsForPartitionLogsAccess"
      effect    = "Allow"
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*move_s3_logs_for_partition*"]
    }
  ]
}

#ROLE6  LambdaRolereputation_lists_parser

module "reputation_lists_parser_iam_role" {
  count               = var.ReputationListsProtectionActivated == "yes" ? 1 : 0
  source              = "../iam"
  role_name           = "lambda_role_reput_parser1_${var.random_id}"
  policy_name         = "lambda_policy_reput_parser1_${var.random_id}"
  assume_role_actions = ["sts:AssumeRole"]
  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  ]

  policy_statements = [
    {
      sid       = "Reputationec2Access"
      effect    = "Allow"
      actions   = ["ec2:CreateNetworkInterface"]
      resources = ["arn:${data.aws_partition.current.partition}:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:/*"]
    },
    {
      sid       = "ReputationLogsAccess"
      effect    = "Allow"
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*reputation_lists_parser*"]
    },
    {
      sid       = "Reputationsqs"
      effect    = "Allow"
      actions   = ["sqs:SendMessage"]
      resources = ["arn:${data.aws_partition.current.partition}:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    },
    {
      sid       = "ReputationCloudWatchAccess"
      effect    = "Allow"
      actions   = ["cloudwatch:GetMetricStatistics"]
      resources = ["*"]
    },
    {
      sid       = "ReputationwafAccess"
      effect    = "Allow"
      actions   = ["wafv2:GetIPSet", "wafv2:UpdateIPSet"]
      resources = ["${var.WAFReputationListsSetV4_arn}", "${var.WAFReputationListsSetV6_arn}"]
    }
  ]
}

#Role 7 - LambdaRoleCustomResource

module "custom_resource_iam_role" {
  count               = var.resolve_count == "yes" ? 1 : 0
  source              = "../iam"
  role_name           = "lambda_role_custom_resource1_${var.random_id}"
  policy_name         = "lambda_policy_custom_resource1_${var.random_id}"
  assume_role_actions = ["sts:AssumeRole"]
  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  ]

  policy_statements = [
    {
      sid       = "customresourceec2Access"
      effect    = "Allow"
      actions   = ["ec2:CreateNetworkInterface"]
      resources = ["arn:${data.aws_partition.current.partition}:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:/*"]
    },
    {
      sid       = "customresourceLogsAccess"
      effect    = "Allow"
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*custom_resource*"]
    },
    {
      sid       = "customresourcesqs"
      effect    = "Allow"
      actions   = ["sqs:SendMessage"]
      resources = ["arn:${data.aws_partition.current.partition}:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    },
    {
      sid       = "customresourceS3AccessGeneralAppAccessLog"
      effect    = "Allow"
      actions   = ["s3:CreateBucket", "s3:GetBucketNotification", "s3:PutBucketNotification", "s3:PutEncryptionConfiguration", "s3:PutBucketPublicAccessBlock"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.AppLogBucket}"]
    },
    {
      sid       = "customresourceS3AccessGeneralWafLog"
      effect    = "Allow"
      actions   = ["s3:CreateBucket", "s3:GetBucketNotification", "s3:PutBucketNotification"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.s3_waf_log_bucket_name}"]
    },
    {
      sid       = "customresourceS3Access"
      effect    = "Allow"
      actions   = ["s3:GetBucketLocation", "s3:GetObject", "s3:ListBucket"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.AppLogBucket}"]
    },
    {
      sid       = "customresourceS3AppAccessPutGeneralWafLog"
      effect    = "Allow"
      actions   = ["s3:CreateBucket", "s3:GetBucketNotification", "s3:PutBucketNotification"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.s3_waf_log_bucket_name}"]
    },
    {
      sid       = "customresourceS3AppAccessPut"
      effect    = "Allow"
      actions   = ["s3:PutObject"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.AppLogBucket}/*app_log_conf.json"]
    },
    {
      sid       = "customresourceS3WafAccessPut"
      effect    = "Allow"
      actions   = ["s3:PutObject"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.s3_waf_log_bucket_name}/*waf_log_conf.json"]
    },
    {
      sid       = "customresourceLambdaAccess"
      effect    = "Allow"
      actions   = ["lambda:InvokeFunction"]
      resources = ["arn:${data.aws_partition.current.partition}:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:*AddAthenaPartitions*", "arn:${data.aws_partition.current.partition}:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:*reputation_lists_parser*"]
    },
    {
      sid       = "customresourceWAFAccess"
      effect    = "Allow"
      actions   = ["wafv2:GetWebACL", "wafv2:UpdateWebACL", "wafv2:DeleteLoggingConfiguration"]
      resources = ["${module.waf_acl[count.index].waf_acl_arn}"]
    },
    {
      sid       = "customresourceIPSetAccess"
      effect    = "Allow"
      actions   = ["wafv2:GetIPSet", "wafv2:UpdateIPSet"]
      resources = ["arn:${data.aws_partition.current.partition}:wafv2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:regional/ipset/*", "arn:${data.aws_partition.current.partition}:wafv2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:global/ipset/*"]
    },
    {
      sid       = "customresourceWAFLogsAccess"
      effect    = "Allow"
      actions   = ["wafv2:PutLoggingConfiguration"]
      resources = ["${module.waf_acl[count.index].waf_acl_arn}"]
    },
    {
      sid       = "customresourceWAFV2LogsAccess"
      effect    = "Allow"
      actions   = ["iam:CreateServiceLinkedRole"]
      resources = ["arn:${data.aws_partition.current.partition}:iam::*:role/aws-service-role/wafv2.amazonaws.com/AWSServiceRoleForWAFV2Logging"]
      conditions = [
        {
          test     = "ForAnyValue:StringLike"
          variable = "iam:AWSServiceName"
          values   = ["wafv2.amazonaws.com"]
        }
      ]
    },
    {
      sid       = "customresourceS3BucketLoggingAccess"
      effect    = "Allow"
      actions   = ["s3:GetBucketLogging", "s3:PutBucketLogging"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.AppLogBucket}"]
    }
  ]
}


#Role 8 - LambdaRoleLogParser

module "log_parser_iam_role" {
  count               = var.LogParser == "yes" ? 1 : 0
  source              = "../iam"
  role_name           = "lambda_role_log_parser1_${var.random_id}"
  policy_name         = "lambda_policy_log_parser1_${var.random_id}"
  assume_role_actions = ["sts:AssumeRole"]
  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  ]

  policy_statements = [
    {
      sid       = "LogParserec2Access"
      effect    = "Allow"
      actions   = ["ec2:CreateNetworkInterface"]
      resources = ["arn:${data.aws_partition.current.partition}:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:/*"]
    },
    {
      sid       = "LogParserLogsAccess"
      effect    = "Allow"
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*logparser*"]
    },
    {
      sid       = "LogParsersqs"
      effect    = "Allow"
      actions   = ["sqs:SendMessage"]
      resources = ["arn:${data.aws_partition.current.partition}:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    },
    {
      sid       = "LogParserS3get"
      effect    = "Allow"
      actions   = ["s3:GetObject"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.AppLogBucket}/*"]
    },
    {
      sid       = "LogParserS3put"
      effect    = "Allow"
      actions   = ["s3:GetObject"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.AppLogBucket}/*app_log_out.json", "arn:${data.aws_partition.current.partition}:s3:::${var.AppLogBucket}/*app_log_conf.json"]
    },
    {
      sid       = "LogParserS3wafv2"
      effect    = "Allow"
      actions   = ["wafv2:GetIPSet", "wafv2:UpdateIPSet"]
      resources = ["${var.WAFScannersProbesSetV4_arn}", "${var.WAFScannersProbesSetV6_arn}"]
    },
    {
      sid       = "LogParsereathena"
      effect    = "Allow"
      actions   = ["athena:GetNamedQuery", "athena:StartQueryExecution"]
      resources = ["arn:${data.aws_partition.current.partition}:athena:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:workgroup/WAF*"]
    },
    {
      sid       = "LogParserS3"
      effect    = "Allow"
      actions   = ["s3:GetBucketLocation", "s3:GetObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:ListMultipartUploadParts", "s3:AbortMultipartUpload", "s3:CreateBucket", "s3:PutObject"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.AppLogBucket}/athena_results/*", "arn:${data.aws_partition.current.partition}:s3:::${var.AppLogBucket}"]
    },
    {
      sid       = "LogParserwafv2"
      effect    = "Allow"
      actions   = ["wafv2:GetIPSet", "wafv2:UpdateIPSet"]
      resources = ["${var.WAFScannersProbesSetV4_arn}", "${var.WAFScannersProbesSetV6_arn}"]
    },
    {
      sid       = "LogParsercatalog"
      effect    = "Allow"
      actions   = ["glue:GetTable", "glue:GetPartitions"]
      resources = ["arn:${data.aws_partition.current.partition}:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:catalog", "arn:${data.aws_partition.current.partition}:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/*", "arn:${data.aws_partition.current.partition}:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/*"]
    },
    {
      sid       = "LogParserWafLogBucketget"
      effect    = "Allow"
      actions   = ["s3:GetObject"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.s3_waf_log_bucket_name}"]
    },
    {
      sid       = "LogParserWafLogBucketPut"
      effect    = "Allow"
      actions   = ["s3:PutObject"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.s3_waf_log_bucket_name}/*log_out.json", "arn:${data.aws_partition.current.partition}:s3:::${var.s3_waf_log_bucket_name}/*log_conf.json"]
    },
    {
      sid       = "LogParserwafhttpset"
      effect    = "Allow"
      actions   = ["wafv2:GetIPSet", "wafv2:UpdateIPSet"]
      resources = ["${var.WAFHttpFloodSetIPV4arn}", "${var.WAFHttpFloodSetIPV6arn}"]
    },
    {
      sid       = "LogParserwafworkgroup"
      effect    = "Allow"
      actions   = ["athena:GetNamedQuery", "athena:StartQueryExecution"]
      resources = ["arn:${data.aws_partition.current.partition}:athena:::${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:workgroup/WAF*"]
    },
    {
      sid       = "LogParserathenaresults"
      effect    = "Allow"
      actions   = ["s3:GetBucketLocation", "s3:GetObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:ListMultipartUploadParts", "s3:AbortMultipartUpload", "s3:CreateBucket", "s3:PutObject"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.s3_waf_log_bucket_name}/athena_results/*", "arn:${data.aws_partition.current.partition}:s3:::${var.s3_waf_log_bucket_name}"]
    },
    {
      sid       = "LogParsergluecatalog"
      effect    = "Allow"
      actions   = ["glue:GetTable", "glue:GetPartitions"]
      resources = ["arn:${data.aws_partition.current.partition}:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:catalog", "arn:${data.aws_partition.current.partition}:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/*", "arn:${data.aws_partition.current.partition}:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/*"]
    },
    {
      sid       = "LogParserS3BucketLoggingAccess"
      effect    = "Allow"
      actions   = ["s3:GetBucketLogging", "s3:PutBucketLogging"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.AppLogBucket}"]
    },
    {
      sid       = "LogParserclodwatchAccess"
      effect    = "Allow"
      actions   = ["cloudwatch:GetMetricStatistics"]
      resources = ["*"]
    }
  ]
}


#Role 10 - CustomTimerrole

module "custom_timer_iam_role" {
  source              = "../iam"
  role_name           = "lambda_role_custom_timer_${var.random_id}"
  policy_name         = "lambda_policy_custom_timer_${var.random_id}"
  assume_role_actions = ["sts:AssumeRole"]
  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  ]

  policy_statements = [
    {
      sid     = "customtimerec2Access"
      effect  = "Allow"
      actions = ["ec2:CreateNetworkInterface"]
      resources = [
        "arn:${data.aws_partition.current.partition}:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:/*"
      ]
    },
    {
      sid     = "customtimerLogsAccess"
      effect  = "Allow"
      actions = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = [
        "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*custom_timer*"
      ]
    },
    {
      sid     = "customtimersqs"
      effect  = "Allow"
      actions = ["sqs:SendMessage"]
      resources = [
        "arn:${data.aws_partition.current.partition}:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
      ]
    }
  ]
}

module "helper_aws_lambda_function" {
  source                         = "../lambda"
  create_lambda                  = true
  function_name                  = "helper_lambda_${var.random_id}"
  description                    = "This lambda function verifies the main project's dependencies, requirements and implement auxiliary functions"
  role_arn                       = module.helper_iam_role.role_arn
  handler                        = "helper.lambda_handler"
  s3_bucket                      = "${var.SourceBucket}-${data.aws_region.current.name}"
  s3_key                         = "${var.KeyPrefix}/helper.zip"
  source_path                    = null
  runtime                        = local.run_time
  timeout                        = 300
  memory_size                    = 128
  kms_key_arn                    = var.kms_key_arn
  retention_in_days              = var.retention_in_days
  reserved_concurrent_executions = 1
  environment_variables = {
    LOG_LEVEL        = var.LOG_LEVEL
    SCOPE            = var.SCOPE
    USER_AGENT_EXTRA = var.USER_AGENT_EXTRA
    Provisioner      = "terraform"
  }
}

module "badbotparser_aws_lambda_function" {
  count                          = var.BadBotProtectionActivated == "yes" ? 1 : 0
  source                         = "../lambda"
  create_lambda                  = true
  function_name                  = "badbotparser_lambda_${var.random_id}"
  description                    = "This lambda function will intercepts and inspects trap endpoint requests to extract its IP address, and then add it to an AWS WAF block list."
  role_arn                       = module.badbot_parser_iam_role[count.index].role_arn
  handler                        = "access_handler.lambda_handler"
  s3_bucket                      = "${var.SourceBucket}-${data.aws_region.current.name}"
  s3_key                         = "${var.KeyPrefix}/access_handler.zip"
  source_path                    = null
  runtime                        = local.run_time
  timeout                        = 300
  memory_size                    = 128
  kms_key_arn                    = var.kms_key_arn
  reserved_concurrent_executions = 1
  retention_in_days              = var.retention_in_days
  environment_variables = {
    LOG_LEVEL                 = var.LOG_LEVEL
    SCOPE                     = var.SCOPE
    USER_AGENT_EXTRA          = var.USER_AGENT_EXTRA
    IP_SET_ID_BAD_BOTV4       = var.WAFBadBotSetV4_arn
    IP_SET_ID_BAD_BOTV6       = var.WAFBadBotSetV6_arn
    IP_SET_NAME_BAD_BOTV4     = var.WAFBadBotSetV4_name
    IP_SET_NAME_BAD_BOTV6     = var.WAFBadBotSetV6_name
    SEND_ANONYMOUS_USAGE_DATA = var.SEND_ANONYMOUS_USAGE_DATA
    REGION                    = data.aws_region.current.name
    LOG_TYPE                  = var.LOG_TYPE
    SOLUTION_ID               = var.SolutionID
    METRICS_URL               = var.MetricsURL
    STACK_NAME                = "custom-resources-stack_${var.random_id}"
    METRIC_NAME_PREFIX        = "customresourcesstack"
    UUID                      = var.random_id
    Provisioner               = "terraform"
    Version                   = var.source_version
  }
}

module "moves3logsforpartition_aws_lambda_function" {
  count                          = var.ScannersProbesAthenaLogParser == "yes" ? 1 : 0
  source                         = "../lambda"
  create_lambda                  = true
  function_name                  = "move_s3_logs_for_partition_lambda_${var.random_id}"
  description                    = "This function is triggered by S3 event to move log files(upon their arrival in s3) from their original location to a partitioned folder structure created per timestamps in file names, hence allowing the usage of partitioning within AWS Athena."
  role_arn                       = module.lambda_role_partition_iam_role[count.index].role_arn
  handler                        = "partition_s3_logs.lambda_handler"
  s3_bucket                      = "${var.SourceBucket}-${data.aws_region.current.name}"
  s3_key                         = "${var.KeyPrefix}/log_parser.zip"
  source_path                    = null
  runtime                        = local.run_time
  timeout                        = 300
  memory_size                    = 512
  kms_key_arn                    = var.kms_key_arn
  reserved_concurrent_executions = 1
  retention_in_days              = var.retention_in_days
  environment_variables = {
    LOG_LEVEL          = var.LOG_LEVEL
    ENDPOINT           = var.ENDPOINT
    USER_AGENT_EXTRA   = var.USER_AGENT_EXTRA
    KEEP_ORIGINAL_DATA = var.KEEP_ORIGINAL_DATA
    Provisioner        = "terraform"
  }
  create_lambda_invoke_permission = true
  permission_principal            = "s3.amazonaws.com"
  permission_source_account       = data.aws_caller_identity.current.account_id
}

module "reputation_lists_parser_aws_lambda_function" {
  count                          = var.ReputationListsProtectionActivated == "yes" ? 1 : 0
  source                         = "../lambda"
  create_lambda                  = true
  function_name                  = "reputation_lists_parser_lambda_${var.random_id}"
  description                    = "This lambda function checks third-party IP reputation lists hourly for new IP ranges to block. These lists include the Spamhaus Dont Route Or Peer (DROP) and Extended Drop (EDROP) lists, the Proofpoint Emerging Threats IP list, and the Tor exit node list."
  role_arn                       = module.reputation_lists_parser_iam_role[count.index].role_arn
  handler                        = "reputation_lists.lambda_handler"
  s3_bucket                      = "${var.SourceBucket}-${data.aws_region.current.name}"
  s3_key                         = "${var.KeyPrefix}/reputation_lists_parser.zip"
  source_path                    = null
  runtime                        = local.run_time
  timeout                        = 300
  memory_size                    = 512
  kms_key_arn                    = var.kms_key_arn
  retention_in_days              = var.retention_in_days
  reserved_concurrent_executions = 1
  environment_variables = {
    LOG_LEVEL                   = var.LOG_LEVEL
    Provisioner                 = "terraform"
    USER_AGENT_EXTRA            = var.USER_AGENT_EXTRA
    IP_SET_ID_REPUTATIONV4      = var.WAFReputationListsSetV4_arn
    IP_SET_ID_REPUTATIONV6      = var.WAFReputationListsSetV6_arn
    IP_SET_NAME_REPUTATIONV4    = var.WAFReputationListsSetV4_name
    IP_SET_NAME_REPUTATIONV6    = var.WAFReputationListsSetV6_name
    SCOPE                       = var.SCOPE
    LOG_TYPE                    = var.LOG_TYPE
    SOLUTION_ID                 = var.SolutionID
    METRICS_URL                 = var.MetricsURL
    SEND_ANONYMOUS_USAGE_DATA   = var.SEND_ANONYMOUS_USAGE_DATA
    IPREPUTATIONLIST_METRICNAME = "MetricForIPReputationListsRule"
    STACK_NAME                  = "custom-resources-stack_${var.random_id}"
    METRIC_NAME_PREFIX          = "customresourcesstack"
    UUID                        = var.random_id
    Version                     = var.source_version
    URL_LIST                    = <<EOF
        [
                    {"url":"https://www.spamhaus.org/drop/drop.txt"},
                    {"url":"https://www.spamhaus.org/drop/edrop.txt"},
                    {"url":"https://check.torproject.org/exit-addresses", "prefix":"ExitAddress"},
                    {"url":"https://rules.emergingthreats.net/fwrules/emerging-Block-IPs.txt"}
                  ]
                  EOF
  }
}

module "custom_resource_aws_lambda_function" {
  count                          = var.resolve_count == "yes" ? 1 : 0
  source                         = "../lambda"
  create_lambda                  = true
  function_name                  = "custom_resource_lambda_${var.random_id}"
  description                    = "Log permissions are defined in the LambdaRoleCustomResource policies"
  role_arn                       = module.custom_resource_iam_role[count.index].role_arn
  handler                        = "custom_resource.lambda_handler"
  s3_bucket                      = "${var.SourceBucket}-${data.aws_region.current.name}"
  s3_key                         = "${var.KeyPrefix}/custom_resource.zip"
  source_path                    = null
  runtime                        = local.run_time
  timeout                        = 300
  memory_size                    = 128
  kms_key_arn                    = var.kms_key_arn
  retention_in_days              = var.retention_in_days
  reserved_concurrent_executions = 1
  environment_variables = {
    LOG_LEVEL        = var.LOG_LEVEL
    USER_AGENT_EXTRA = var.USER_AGENT_EXTRA
    SCOPE            = var.SCOPE
    SOLUTION_ID      = var.SolutionID
    METRICS_URL      = var.MetricsURL
    UUID             = var.random_id
    Provisioner      = "terraform"
  }
}

module "log_parser_aws_lambda_function" {
  count                          = var.LogParser == "yes" ? 1 : 0
  source                         = "../lambda"
  create_lambda                  = true
  function_name                  = "logparser_lambda_${var.random_id}"
  description                    = "This function parses access logs to identify suspicious behavior, such as an abnormal amount of errors.It then blocks those IP addresses for a customer-defined period of time."
  role_arn                       = module.log_parser_iam_role[count.index].role_arn
  handler                        = "log_parser.lambda_handler"
  s3_bucket                      = "${var.SourceBucket}-${data.aws_region.current.name}"
  s3_key                         = "${var.KeyPrefix}/log_parser.zip"
  source_path                    = null
  runtime                        = local.run_time
  timeout                        = 300
  memory_size                    = 512
  kms_key_arn                    = var.kms_key_arn
  retention_in_days              = var.retention_in_days
  reserved_concurrent_executions = 1
  environment_variables = {
    APP_ACCESS_LOG_BUCKET                          = var.AppLogBucket
    WAF_ACCESS_LOG_BUCKET                          = var.WafLogBucket
    LIMIT_IP_ADDRESS_RANGES_PER_IP_MATCH_CONDITION = 10000
    MAX_AGE_TO_UPDATE                              = 30
    LOG_LEVEL                                      = var.LOG_LEVEL
    SCOPE                                          = var.SCOPE
    UUID                                           = var.random_id
    USER_AGENT_EXTRA                               = var.USER_AGENT_EXTRA
    SEND_ANONYMOUS_USAGE_DATA                      = var.SEND_ANONYMOUS_USAGE_DATA
    REGION                                         = data.aws_region.current.name
    LOG_TYPE                                       = var.LOG_TYPE
    SOLUTION_ID                                    = var.SolutionID
    METRICS_URL                                    = var.MetricsURL
    IP_SET_ID_HTTP_FLOODV4                         = var.WAFHttpFloodSetIPV4arn
    IP_SET_ID_HTTP_FLOODV6                         = var.WAFHttpFloodSetIPV6arn
    IP_SET_NAME_HTTP_FLOODV4                       = var.WAFHttpFloodSetIPV4Name
    IP_SET_NAME_HTTP_FLOODV6                       = var.WAFHttpFloodSetIPV6Name
    IP_SET_ID_SCANNERS_PROBESV4                    = var.WAFScannersProbesSetV4_arn
    IP_SET_ID_SCANNERS_PROBESV6                    = var.WAFScannersProbesSetV6_arn
    IP_SET_NAME_SCANNERS_PROBESV4                  = var.WAFScannersProbesSetV4_name
    IP_SET_NAME_SCANNERS_PROBESV6                  = var.WAFScannersProbesSetV6_name
    WAF_BLOCK_PERIOD                               = var.WAFBlockPeriod
    ERROR_THRESHOLD                                = var.ErrorThreshold
    REQUEST_THRESHOLD                              = var.RequestThreshold
    REQUEST_THRESHOLD_BY_COUNTRY                   = var.RequestThresholdByCountryParam
    HTTP_FLOOD_ATHENA_GROUP_BY                     = var.HTTPFloodAthenaQueryGroupByParam
    ATHENA_QUERY_RUN_SCHEDULE                      = var.AthenaQueryRunTimeScheduleParam
    STACK_NAME                                     = "custom-resources-stack_${var.random_id}"
    METRIC_NAME_PREFIX                             = "customresourcesstack"
    Provisioner                                    = "terraform"
    Version                                        = var.source_version
  }
}

module "lambda_athena_waf_logparser_lambda_permission" {
  count                           = var.HttpFloodAthenaLogParser == "yes" ? 1 : 0
  source                          = "../eventbridge"
  create_lambda_invoke_permission = true
  function_name                   = module.log_parser_aws_lambda_function[count.index].lambda_name
  permission_principal            = "events.amazonaws.com"
  permission_source_arn           = module.lambda_athena_waf_logparser[count.index].arn
}

module "lambda_athena_app_logparser_lambda_permission" {
  count                           = var.ScannersProbesAthenaLogParser == "yes" ? 1 : 0
  source                          = "../eventbridge"
  create_lambda_invoke_permission = true
  function_name                   = module.log_parser_aws_lambda_function[count.index].lambda_name
  permission_principal            = "events.amazonaws.com"
  permission_source_arn           = module.lambda_athena_app_logparser[count.index].arn
}

module "log_parsers3_lambda_permission" {
  count                           = var.LogParser == "yes" ? 1 : 0
  source                          = "../eventbridge"
  create_lambda_invoke_permission = true
  function_name                   = module.log_parser_aws_lambda_function[count.index].lambda_arn
  permission_principal            = "s3.amazonaws.com"
  permission_source_account       = data.aws_caller_identity.current.account_id
}

module "moves3logs_lambda_permission" {
  count                           = var.LogParser == "yes" && var.ScannersProbesAthenaLogParser == "yes" ? 1 : 0
  source                          = "../eventbridge"
  create_lambda_invoke_permission = true
  function_name                   = module.moves3logsforpartition_aws_lambda_function[count.index].lambda_arn
  permission_principal            = "s3.amazonaws.com"
  permission_source_account       = data.aws_caller_identity.current.account_id
}

module "custom_timer_aws_lambda_function" {
  count                          = var.IPRetentionPeriod == "yes" ? 1 : 0
  source                         = "../lambda"
  create_lambda                  = true
  function_name                  = "custom_timer_Lambda_${var.random_id}"
  description                    = "This lambda function counts X seconds and can be used to slow down component creation in CloudFormation"
  role_arn                       = module.custom_timer_iam_role.role_arn
  handler                        = "timer.lambda_handler"
  s3_bucket                      = "${var.SourceBucket}-${data.aws_region.current.name}"
  s3_key                         = "${var.KeyPrefix}/timer.zip"
  source_path                    = null
  runtime                        = local.run_time
  timeout                        = 300
  memory_size                    = 128
  kms_key_arn                    = var.kms_key_arn
  retention_in_days              = var.retention_in_days
  reserved_concurrent_executions = 1
  environment_variables = {
    LOG_LEVEL   = var.LOG_LEVEL
    SECONDS     = "2"
    Provisioner = "terraform"
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE A EVENT RULES
# ----------------------------------------------------------------------------------------------------------------------

module "lambda_athena_waf_logparser" {
  count             = var.HttpFloodAthenaLogParser == "yes" ? 1 : 0
  source            = "../eventbridge"
  create_event_rule = true
  name              = "lambda_athena_waf_log_parser_rule_${var.random_id}"
  description       = "Security Automations - WAF Logs Athena parser"
  frequency_type    = "rate(${var.AthenaQueryRunTimeScheduleParam} minutes)"
  target_arn        = module.log_parser_aws_lambda_function[count.index].lambda_arn
  target_id         = "LogParser"
  input = jsonencode(
    {
      "resourceType" : "lambda_athena_waf_logparser",
      "glueAccessLogsDatabase" : "${var.glue_database_name}",
      "accessLogBucket" : "${var.AppLogBucket}",
      "glueWafAccessLogsTable" : "${var.waf_access_logs_table_name}",
      "athenaWorkGroup" : "${var.waf_app_access_log_athena_query_workgroup_name}"
    }
  )
}

module "lambda_athena_app_logparser" {
  count             = var.ScannersProbesAthenaLogParser == "yes" ? 1 : 0
  source            = "../eventbridge"
  create_event_rule = true
  name              = "lambda_athena_app_log_parser_rule_${var.random_id}"
  description       = "Security Automation - App Logs Athena parser"
  frequency_type    = "rate(${var.AthenaQueryRunTimeScheduleParam} minutes)"
  target_arn        = module.log_parser_aws_lambda_function[count.index].lambda_arn
  target_id         = "LogParser"
  input = jsonencode(
    {
      "resourceType" : "lambda_athena_app_logparser",
      "glueAccessLogsDatabase" : "${var.glue_database_name}",
      "accessLogBucket" : "${var.AppLogBucket}",
      "glueAppAccessLogsTable" : "${var.AppAccessLogsTable}",
      "athenaWorkGroup" : "${var.waf_app_access_log_athena_query_workgroup_name}"
    }
  )
}

module "reputation_lists_parser" {
  count             = var.ReputationListsProtectionActivated == "yes" ? 1 : 0
  create_event_rule = true
  source            = "../eventbridge"
  name              = "reputation_events_rule_${var.random_id}"
  description       = "Security Automation - WAF Reputation Lists"
  frequency_type    = "rate(1 hour)"
  target_arn        = module.reputation_lists_parser_aws_lambda_function[count.index].lambda_arn
  target_id         = "reputation_lists_parser"
  input = jsonencode(
    {
      "URL_LIST" : [
        { "url" : "https://www.spamhaus.org/drop/drop.txt" },
        { "url" : "https://www.spamhaus.org/drop/edrop.txt" },
        { "url" : "https://check.torproject.org/exit-addresses", "prefix" : "ExitAddress" },
        { "url" : "https://rules.emergingthreats.net/fwrules/emerging-Block-IPs.txt" }
      ],
      "IP_SET_ID_REPUTATIONV4" : "${var.WAFReputationListsSetV4_arn}",
      "IP_SET_ID_REPUTATIONV6" : "${var.WAFReputationListsSetV6_arn}",
      "IP_SET_NAME_REPUTATIONV4" : "${var.WAFReputationListsSetV4_name}",
      "IP_SET_NAME_REPUTATIONV6" : "${var.WAFReputationListsSetV6_name}",
      "SCOPE" : "${var.SCOPE}"
    }
  )
  create_lambda_invoke_permission = true
  permission_principal            = "events.amazonaws.com"
  function_name                   = module.reputation_lists_parser_aws_lambda_function[count.index].lambda_name
}

resource "aws_lambda_invocation" "UpdateReputationListsOnLoad" {
  count         = var.ReputationListsProtectionActivated == "yes" ? 1 : 0
  function_name = module.reputation_lists_parser_aws_lambda_function[count.index].lambda_name

  input = <<JSON
{
  "provisioner": "terraform"
}
JSON
}

# ----------------------------------------------------------------------------------------------------------------------
# API gateway
# ----------------------------------------------------------------------------------------------------------------------

module "api_gateway" {
  count               = var.BadBotProtectionActivated == "yes" ? 1 : 0
  source              = "../apigateway"
  name                = "waf_bad_bot_api_${var.random_id}"
  description         = "API created by AWS WAF Security Automation CloudFormation template. This endpoint will be used to capture bad bots."
  stage_name          = "CFDeploymentStage"
  api_stage           = var.api_stage
  kms_key_arn         = var.kms_key_arn
  cloudwatch_role_arn = module.api_gateway_badbot_cloudwatchrole[count.index].role_arn
  function_name       = module.badbotparser_aws_lambda_function[count.index].lambda_arn
  uri                 = "arn:${data.aws_partition.current.partition}:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${module.badbotparser_aws_lambda_function[count.index].lambda_arn}/invocations"
}

module "api_gateway_badbot_cloudwatchrole" {
  count               = var.BadBotProtectionActivated == "yes" ? 1 : 0
  source              = "../iam"
  role_name           = "badbot_role_${var.random_id}"
  policy_name         = "badbot_policy_${var.random_id}"
  assume_role_actions = ["sts:AssumeRole"]
  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  ]

  policy_statements = [
    {
      sid       = "badbodlogsAccess"
      effect    = "Allow"
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents", "logs:DescribeLogGroups", "logs:DescribeLogStreams", "logs:GetLogEvents", "logs:FilterLogEvents"]
      resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    }
  ]
}