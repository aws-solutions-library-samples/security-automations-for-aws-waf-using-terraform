data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# ----------------------------------------------------------------------------------------------------------------------
# IP Retention resource
# ----------------------------------------------------------------------------------------------------------------------

###SNS

module "waf_sns" {
  count  = local.SNSEmail == "yes" ? 1 : 0
  source = "../sns"
  name = join("-", [
    "AWS-WAF-Security-Automations-IP-Expiration-Notification",
    "${var.random_id}"
  ])
  kms_master_key_id = "alias/aws/sns"
  protocol          = "email"
  SNSEmailParam     = var.SNSEmailParam
}

module "set_ip_retention_aws_lambda_function" {
  count                          = var.IPRetentionPeriod == "yes" ? 1 : 0
  source                         = "../lambda"
  create_lambda                  = true
  function_name                  = "setipretention_lambda_${var.random_id}"
  description                    = "This lambda function processes CW events for WAF UpdateIPSet API calls. It writes relevant ip retention data into a DynamoDB table."
  role_arn                       = module.set_ip_retention_iam_role[count.index].role_arn
  handler                        = "set_ip_retention.lambda_handler"
  s3_bucket                      = "${var.SourceBucket}-${data.aws_region.current.name}"
  s3_key                         = "${var.KeyPrefix}/ip_retention_handler.zip"
  source_path                    = null
  runtime                        = local.run_time
  timeout                        = 300
  memory_size                    = 128
  kms_key_arn                    = var.kms_key_arn
  retention_in_days              = var.retention_in_days
  reserved_concurrent_executions = 1
  environment_variables = {
    LOG_LEVEL                          = var.LOG_LEVEL
    USER_AGENT_EXTRA                   = var.USER_AGENT_EXTRA
    TABLE_NAME                         = module.ip_retention_ddb_table[count.index].dynamodb_arn
    IP_RETENTION_PEROID_ALLOWED_MINUTE = var.IPRetentionPeriodAllowedParam
    IP_RETENTION_PEROID_DENIED_MINUTE  = var.IPRetentionPeriodDeniedParam
    REMOVE_EXPIRED_IP_LAMBDA_ROLE_NAME = module.remove_expired_ip_iam_role[count.index].role_name
    STACK_NAME                         = "custom-resources-stack_${var.random_id}"
    METRIC_NAME_PREFIX                 = "customresourcesstack"
    Provisioner                        = "terraform"
  }
}


# ----------------------------------------------------------------------------------------------------------------------
# Dynamo DB table -This DynamoDB table constains transactional ip retention data that will be expired by DynamoDB TTL. The data doesn't need to be retained after its lifecycle ends.
# ----------------------------------------------------------------------------------------------------------------------

module "ip_retention_ddb_table" {
  count                              = var.IPRetentionPeriod == "yes" ? 1 : 0
  source                             = "../dynamodb"
  name                               = "ip_retention_ddb_table_${var.random_id}"
  billing_mode                       = "PAY_PER_REQUEST"
  stream_enabled                     = true
  stream_view_type                   = "OLD_IMAGE"
  hash_key                           = "IPSetId"
  range_key                          = "ExpirationTime"
  ttl_enabled                        = true
  ttl_attribute_name                 = "ExpirationTime"
  point_in_time_recovery_enabled     = true
  server_side_encryption_enabled     = true
  server_side_encryption_kms_key_arn = var.kms_key_arn

  attributes = [
    {
      name = "IPSetId"
      type = "S"
    },
    {
      name = "ExpirationTime"
      type = "N"
    }
  ]
}

#Role 4 - LambdaRoleSetIPRetention

module "set_ip_retention_iam_role" {
  count               = var.IPRetentionPeriod == "yes" ? 1 : 0
  source              = "../iam"
  role_name           = "lambda_role_set_ipretention1_${var.random_id}"
  policy_name         = "lambda_policy_set_ipretention1_${var.random_id}"
  assume_role_actions = ["sts:AssumeRole"]
  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  ]

  policy_statements = [
    {
      sid       = "SetIPRetentionLogsAccess"
      effect    = "Allow"
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*SetIPRetention*"]
    },
    {
      sid       = "dynamodbaccess"
      effect    = "Allow"
      actions   = ["dynamodb:PutItem"]
      resources = ["${module.ip_retention_ddb_table[count.index].dynamodb_arn}"]
    }
  ]
}

module "set_ip_retention" {
  count             = var.IPRetentionPeriod == "yes" ? 1 : 0
  create_event_rule = true
  source            = "../eventbridge"
  name              = "ip_retention_periods_rule_${var.random_id}"
  description       = "AWS WAF Security Automations - Events rule for setting IP retention"
  frequency_type    = "rate(1 hour)"
  target_arn        = module.set_ip_retention_aws_lambda_function[count.index].lambda_arn
  target_id         = "SetIPRetentionLambda"
  event_pattern = jsonencode(
    {
      "detail-type" : ["AWS API Call via CloudTrail"],
      "source" : ["aws.wafv2"],
      "detail" : {
        "eventSource" : ["wafv2.amazonaws.com"],
        "eventName" : ["UpdateIPSet"],
        "requestParameters" : [
          "${var.WAFWhitelistSetV4_name}",
          "${var.WAFBlacklistSetV4_name}",
          "${var.WAFWhitelistSetV6_name}",
          "${var.WAFBlacklistSetV6_name}"
        ]
      }
    }
  )
  create_lambda_invoke_permission = true
  permission_principal            = "events.amazonaws.com"
  function_name                   = module.set_ip_retention_aws_lambda_function[count.index].lambda_name
}

#Role 5 - LambdaRoleRemoveExpiredIP

module "remove_expired_ip_iam_role" {
  count               = var.IPRetentionPeriod == "yes" ? 1 : 0
  source              = "../iam"
  role_name           = "lambda_role_remove_expired_ip1_${var.random_id}"
  policy_name         = "lambda_policy_remove_expired_ip1_${var.random_id}"
  assume_role_actions = ["sts:AssumeRole"]
  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  ]
  policy_statements = [
    {
      sid       = "LogsAccess"
      effect    = "Allow"
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*RemoveExpiredIP*"]
    },
    {
      sid     = "WAFAccess"
      effect  = "Allow"
      actions = ["wafv2:GetIPSet", "wafv2:UpdateIPSet"]
      resources = ["${var.WAFWhitelistSetV4_arn}",
        "${var.WAFBlacklistSetV4_arn}",
        "${var.WAFWhitelistSetV6_arn}",
      "${var.WAFBlacklistSetV6_arn}"]
    },
    {
      sid       = "SetIPRetentionDDBStreamAccess"
      effect    = "Allow"
      actions   = ["dynamodb:GetShardIterator", "dynamodb:DescribeStream", "dynamodb:GetRecords", "dynamodb:ListStreams"]
      resources = ["${module.ip_retention_ddb_table[count.index].dynamodb_stream_arn}"]
    },
    {
      sid       = "SetIPRetentionInvokeLambdaAccess"
      effect    = "Allow"
      actions   = ["lambda:InvokeFunction"]
      resources = ["${module.ip_retention_ddb_table[count.index].dynamodb_stream_arn}"]
    }
  ]
}

module "remove_expired_ip_aws_lambda_function" {
  count                          = var.IPRetentionPeriod == "yes" ? 1 : 0
  source                         = "../lambda"
  create_lambda                  = true
  function_name                  = "remove_expired_ip_lambda_${var.random_id}"
  description                    = "This lambda function processes the DDB streams records (IP) expired by TTL. It removes expired IPs from WAF allowed or denied IP sets."
  role_arn                       = module.remove_expired_ip_iam_role[count.index].role_arn
  handler                        = "remove_expired_ip.lambda_handler"
  s3_bucket                      = "${var.SourceBucket}-${data.aws_region.current.name}"
  s3_key                         = "${var.KeyPrefix}/ip_retention_handler.zip"
  source_path                    = null
  runtime                        = local.run_time
  timeout                        = 300
  memory_size                    = 512
  kms_key_arn                    = var.kms_key_arn
  retention_in_days              = var.retention_in_days
  reserved_concurrent_executions = 1
  environment_variables = {
    LOG_LEVEL                 = var.LOG_LEVEL
    USER_AGENT_EXTRA          = var.USER_AGENT_EXTRA
    METRICS_URL               = var.MetricsURL
    SOLUTION_ID               = var.SolutionID
    UUID                      = var.random_id
    SEND_ANONYMOUS_USAGE_DATA = var.SEND_ANONYMOUS_USAGE_DATA
    SNS_EMAIL                 = local.SNSEmail
    SNS_TOPIC_ARN             = module.waf_sns[count.index].sns_arn
    Provisioner               = "terraform"
    Version                   = var.source_version
  }
}

resource "aws_lambda_event_source_mapping" "example" {
  count             = var.IPRetentionPeriod == "yes" ? 1 : 0
  enabled           = true
  event_source_arn  = module.ip_retention_ddb_table[0].dynamodb_stream_arn
  function_name     = module.remove_expired_ip_aws_lambda_function[0].lambda_arn
  starting_position = "LATEST"
}

