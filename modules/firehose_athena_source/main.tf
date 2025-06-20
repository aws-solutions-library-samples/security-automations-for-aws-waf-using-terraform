data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# ----------------------------------------------------------------------------------------------------------------------
# Firehose Athena
# ----------------------------------------------------------------------------------------------------------------------

module "add_athena_partitions_iam_role" {
  count               = var.AthenaLogParser == "yes" ? 1 : 0
  source              = "../iam"
  role_name           = "lambda_role_add_athena_partitions1_${var.random_id}"
  policy_name         = "lambda_policy_add_athena_partitions1_${var.random_id}"
  assume_role_actions = ["sts:AssumeRole"]
  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  ]

  policy_statements = [
    {
      sid       = "AthenaLogParserec2Access"
      effect    = "Allow"
      actions   = ["ec2:CreateNetworkInterface"]
      resources = ["arn:${data.aws_partition.current.partition}:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:/*"]
    },
    {
      sid       = "AthenaLogParserLogsAccess"
      effect    = "Allow"
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/add_athena_partitions*"]
    },
    {
      sid       = "AthenaLogParsersqs"
      effect    = "Allow"
      actions   = ["sqs:SendMessage"]
      resources = ["arn:${data.aws_partition.current.partition}:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    },
    {
      sid       = "AthenalogparserqueryAccess"
      effect    = "Allow"
      actions   = ["athena:StartQueryExecution"]
      resources = ["arn:${data.aws_partition.current.partition}:athena:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:workgroup/*"]
    },
    {
      sid       = "athanlogparsers3accessresults"
      effect    = "Allow"
      actions   = ["s3:GetBucketLocation", "s3:GetObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:ListMultipartUploadParts", "s3:AbortMultipartUpload", "s3:CreateBucket", "s3:PutObject"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.AppLogBucket}/athena_results/*", "arn:${data.aws_partition.current.partition}:s3:::${var.AppLogBucket}", "arn:${data.aws_partition.current.partition}:s3:::${var.AppLogBucket}/*"]
    },
    {
      sid       = "athanlogparserglueresults"
      effect    = "Allow"
      actions   = ["glue:GetTable", "glue:GetDatabase", "glue:UpdateDatabase", "glue:CreateDatabase", "glue:BatchCreatePartition"]
      resources = ["arn:${data.aws_partition.current.partition}:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:catalog", "arn:${data.aws_partition.current.partition}:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/default", "arn:${data.aws_partition.current.partition}:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/*", "arn:${data.aws_partition.current.partition}:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/*"]
    },
    {
      sid       = "athanlogparserwafs3accessresults"
      effect    = "Allow"
      actions   = ["s3:GetBucketLocation", "s3:GetObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:ListMultipartUploadParts", "s3:AbortMultipartUpload", "s3:CreateBucket", "s3:PutObject"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.s3_waf_log_bucket_name}/athena_results/*", "arn:${data.aws_partition.current.partition}:s3:::${var.s3_waf_log_bucket_name}", "arn:${data.aws_partition.current.partition}:s3:::${var.s3_waf_log_bucket_name}/*"]
    }
  ]
}

module "firehose_athena_iam_role" {
  count               = var.HttpFloodProtectionLogParserActivated == "yes" ? 1 : 0
  source              = "../iam"
  role_name           = "firehose_waf_logs_delivery_stream_role_${var.random_id}"
  policy_name         = "firehose_waf_logs_delivery_stream_policy_${var.random_id}"
  assume_role_actions = ["sts:AssumeRole"]
  assume_role_principals = [
    {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  ]

  policy_statements = [
    {
      sid     = "firehoseathenaec2Access"
      effect  = "Allow"
      actions = ["s3:GetBucketLocation", "s3:GetObject", "s3:ListBucket", "s3:AbortMultipartUpload", "s3:ListBucketMultipartUploads", "s3:PutObject"]
      resources = [
        "arn:${data.aws_partition.current.partition}:s3:::${var.s3_waf_log_bucket_name}", "arn:${data.aws_partition.current.partition}:s3:::${var.s3_waf_log_bucket_name}/*"
      ]
    },
    {
      sid     = "KinesisAccess"
      effect  = "Allow"
      actions = ["kinesis:DescribeStream", "kinesis:GetShardIterator", "kinesis:GetRecords"]
      resources = [
        "arn:${data.aws_partition.current.partition}:kinesis:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stream/${var.DeliveryStreamName}-${var.random_id}"
      ]
    },
    {
      sid     = "kinesiscloudWatchAccess"
      effect  = "Allow"
      actions = ["logs:PutLogEvents"]
      resources = [
        "arn:${data.aws_partition.current.partition}:kinesis:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/kinesisfirehose/${var.DeliveryStreamName}-${var.random_id}:*"
      ]
    }
  ]
}

module "add_athena_partitions_aws_lambda_function" {
  count                          = var.AthenaLogParser == "yes" ? 1 : 0
  source                         = "../lambda"
  create_lambda                  = true
  function_name                  = "add_athena_partitions_${var.random_id}"
  description                    = "This function adds a new hourly partition to athena table. It runs every hour, triggered by a CloudWatch event."
  role_arn                       = module.add_athena_partitions_iam_role[count.index].role_arn
  handler                        = "add_athena_partitions.lambda_handler"
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
    LOG_LEVEL        = var.LOG_LEVEL
    USER_AGENT_EXTRA = var.USER_AGENT_EXTRA
    Provisioner      = "terraform"
  }
}

module "firehose_athena" {
  count                   = var.HttpFloodProtectionLogParserActivated == "yes" ? 1 : 0
  source                  = "../firehose"
  DeliveryStreamName      = "${var.DeliveryStreamName}-${var.random_id}"
  kms_key_arn             = var.kms_key_arn
  bucket_arn              = var.s3_waf_log_bucket_arn
  firehouseathena_rolearn = module.firehose_athena_iam_role[count.index].role_arn
}


# ----------------------------------------------------------------------------------------------------------------------
# Glue Database and tables
# ----------------------------------------------------------------------------------------------------------------------

module "glue_catalog_database" {
  count      = var.AthenaLogParser == "yes" ? 1 : 0
  source     = "../glue-database"
  name       = "${var.glue_catalog_database_name}-${var.random_id}"
  catalog_id = data.aws_caller_identity.current.account_id
}


module "waf_access_logs_table" {
  count              = var.HttpFloodAthenaLogParser == "yes" ? 1 : 0
  source             = "../glue-table"
  catalog_table_name = "waf_access_logs_${var.random_id}"
  database_name      = module.glue_catalog_database[count.index].name
  catalog_id         = data.aws_caller_identity.current.account_id

  parameters = {
    EXTERNAL = "TRUE"
  }

  partition_keys = {
    columns = [
      {
        name = "year",
        type = "int"
      },
      {
        name = "month",
        type = "int"
      },
      {
        name = "day",
        type = "int"
      },
      {
        name = "hour",
        type = "int"
      }
    ]
  }

  storage_descriptor = {
    bucket_columns = null
    compressed     = true
    input_format   = "org.apache.hadoop.mapred.TextInputFormat"
    location       = "s3://${var.s3_waf_log_bucket_name}/AWSLogs/"
    output_format  = "org.apache.hadoop.hive.ql.io.IgnoreKeyTextOutputFormat"
    ser_de_info = {
      parameters = {
        "paths" = "action,formatVersion,httpRequest,httpSourceId,httpSourceName,nonTerminatingMatchingRules,rateBasedRuleList,ruleGroupList,terminatingRuleId,terminatingRuleType,timestamp,webaclId"
      }
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }
    stored_as_sub_directories = false
    #columns                   = var.waf_access_logs_columns
  }
  logs_columns = var.waf_access_logs_columns
}

module "alb_glue_app_access_logs_table" {
  count              = var.AthenaLogParser == "yes" && var.ALBScannersProbesAthenaLogParser == "yes" ? 1 : 0
  source             = "../glue-table"
  catalog_table_name = "app_access_logs_${var.random_id}"
  database_name      = module.glue_catalog_database[count.index].name
  catalog_id         = data.aws_caller_identity.current.account_id

  parameters = {
    EXTERNAL = "TRUE"
  }
  partition_keys = {
    columns = [
      {
        name = "year",
        type = "int"
      },
      {
        name = "month",
        type = "int"
      },
      {
        name = "day",
        type = "int"
      },
      {
        name = "hour",
        type = "int"
      }
    ]
  }

  storage_descriptor = {
    bucket_columns = null
    compressed     = true
    input_format   = "org.apache.hadoop.mapred.TextInputFormat"
    location       = "s3://${var.AppLogBucket}/AWSLogs-Partitioned/"
    output_format  = "org.apache.hadoop.hive.ql.io.IgnoreKeyTextOutputFormat"
    ser_de_info = {
      parameters = {
        "serialization.format" = "1"
        "input.regex"          = "([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*):([0-9]*) ([^ ]*)[:-]([0-9]*) ([-.0-9]*) ([-.0-9]*) ([-.0-9]*) (|[-0-9]*) (-|[-0-9]*) ([-0-9]*) ([-0-9]*) \"([^ ]*) ([^ ]*) (- |[^ ]*)\" \"([^\"]*)\" ([A-Z0-9-]+) ([A-Za-z0-9.-]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^\"]*)\" ([-.0-9]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\"($| \"[^ ]*\")(.*)"
      }
      serialization_library = "org.apache.hadoop.hive.serde2.RegexSerDe"
    }
    stored_as_sub_directories = false
  }
  logs_columns = var.app_access_logs_columns
}


module "cloudfront_glue_app_access_logs_table" {
  count              = var.AthenaLogParser == "yes" && var.CloudFrontScannersProbesAthenaLogParser == "yes" ? 1 : 0
  source             = "../glue-table"
  catalog_table_name = "app_access_logs_${var.random_id}"
  database_name      = module.glue_catalog_database[count.index].name
  catalog_id         = data.aws_caller_identity.current.account_id

  parameters = {
    "skip.header.line.count" = "2",
    "EXTERNAL"               = "TRUE"
  }
  partition_keys = {
    columns = [
      {
        name = "year",
        type = "int"
      },
      {
        name = "month",
        type = "int"
      },
      {
        name = "day",
        type = "int"
      },
      {
        name = "hour",
        type = "int"
      }
    ]
  }

  storage_descriptor = {
    bucket_columns = null
    compressed     = true
    input_format   = "org.apache.hadoop.mapred.TextInputFormat"
    location       = "s3://${var.AppLogBucket}/AWSLogs-Partitioned/"
    output_format  = "org.apache.hadoop.hive.ql.io.IgnoreKeyTextOutputFormat"
    ser_de_info = {
      parameters = {
        "serialization.format" = "\t",
        "field.delim"          = "\t"
      }
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    }
    stored_as_sub_directories = true
    #columns                   = var.cloudfront_app_access_logs_columns
  }
  logs_columns = var.cloudfront_app_access_logs_columns
}

# ----------------------------------------------------------------------------------------------------------------------
# Athena Work Group
# ----------------------------------------------------------------------------------------------------------------------


module "waf_add_partition_athena_query_workgroup" {
  count                              = var.AthenaLogParser == "yes" ? 1 : 0
  source                             = "../athena"
  name                               = "waf_add_partition_athena_query_workgroup_${var.random_id}"
  description                        = "Athena WorkGroup for adding Athena partition queries used by AWS WAF Security Automations Solution"
  publish_cloudwatch_metrics_enabled = "true"
  workgroup_encryption_option        = "SSE_KMS"
  kms_key_arn                        = var.kms_key_arn
  output_location                    = "s3://${var.AppLogBucket}/outputwaf_app_access_log_athena_query_workgroup/"
  workgroup_force_destroy            = "true"
}

module "waf_log_athena_query_workgroup" {
  count                              = var.HttpFloodAthenaLogParser == "yes" ? 1 : 0
  source                             = "../athena"
  name                               = "waf_log_athena_query_workgroup_${var.random_id}"
  description                        = "Athena WorkGroup for WAF log queries used by AWS WAF Security Automations Solution"
  publish_cloudwatch_metrics_enabled = "true"
  workgroup_encryption_option        = "SSE_KMS"
  kms_key_arn                        = var.kms_key_arn
  output_location                    = "s3://${var.AppLogBucket}/outputwaf_app_access_log_athena_query_workgroup/"
  workgroup_force_destroy            = "true"
}

module "waf_app_access_log_athena_query_workgroup" {
  count                              = var.ScannersProbesAthenaLogParser == "yes" ? 1 : 0
  source                             = "../athena"
  name                               = "waf_app_access_log_athena_query_workgroup_${var.random_id}"
  description                        = "Athena WorkGroup for CloudFront or ALB application access log queries used by AWS WAF Security Automations Solution"
  publish_cloudwatch_metrics_enabled = "true"
  workgroup_encryption_option        = "SSE_KMS"
  kms_key_arn                        = var.kms_key_arn
  output_location                    = "s3://${var.AppLogBucket}/outputwaf_app_access_log_athena_query_workgroup/"
  workgroup_force_destroy            = "true"
}

module "lambda_add_athena_partitions" {
  count             = var.AthenaLogParser == "yes" ? 1 : 0
  source            = "../eventbridge"
  create_event_rule = true
  name              = "lambda_add_athena_partitions_events_rule_${var.random_id}"
  description       = "Security Automations - Add partitions to Athena table"
  frequency_type    = "cron(* ? * * * *)"
  target_arn        = module.add_athena_partitions_aws_lambda_function[count.index].lambda_arn
  target_id         = "lambda_add_athena_partitions"
  input = jsonencode(
    {
      "resourceType" : "LambdaAddAthenaPartitionsEventsRule",
      "glueAccessLogsDatabase" : "${module.glue_catalog_database[count.index].name}",
      "accessLogBucket" : "${try(var.AppLogBucket, "")}",
      "glueAppAccessLogsTable" : "${try(module.alb_glue_app_access_logs_table[0].name, "")}",
      "glueWafAccessLogsTable" : "${try(module.waf_access_logs_table[0].name, "")}",
      "wafLogBucket" : "${try(var.s3_waf_log_bucket_name, "")}",
      "athenaWorkGroup" : "${module.waf_add_partition_athena_query_workgroup[count.index].athena_workgroup_name}"
    }
  )
  create_lambda_invoke_permission = true
  permission_principal            = "events.amazonaws.com"
  function_name                   = module.add_athena_partitions_aws_lambda_function[count.index].lambda_arn
}

resource "aws_lambda_invocation" "add_athena_partitions" {
  count         = var.AthenaLogParser == "yes" ? 1 : 0
  function_name = module.add_athena_partitions_aws_lambda_function[count.index].lambda_name

  input = jsonencode(
    {
      "resourceType" : "CustomResource",
      "provisioner" : "terraform",
      "glueAccessLogsDatabase" : module.glue_catalog_database[0].name,
      "accessLogBucket" : try(var.AppLogBucket, ""),
      "glueAppAccessLogsTable" : try(module.alb_glue_app_access_logs_table[0].name, ""),
      "glueWafAccessLogsTable" : try(module.waf_access_logs_table[0].name, ""),
      "wafLogBucket" : try(var.s3_waf_log_bucket_name, ""),
      "athenaWorkGroup" : module.waf_add_partition_athena_query_workgroup[0].athena_workgroup_name
    }
  )
}