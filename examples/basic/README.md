<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0, < 5.0.0 |
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | >= 0.24.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0, < 5.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dashboard"></a> [dashboard](#module\_dashboard) | ../../modules/cloudwatch | n/a |
| <a name="module_firehouse_athena_source"></a> [firehouse\_athena\_source](#module\_firehouse\_athena\_source) | ../../modules/firehose_athena_source | n/a |
| <a name="module_ip_retention_resource"></a> [ip\_retention\_resource](#module\_ip\_retention\_resource) | ../../modules/ip_retention_resource | n/a |
| <a name="module_ip_sets"></a> [ip\_sets](#module\_ip\_sets) | ../../modules/waf | n/a |
| <a name="module_s3_access_logging_bucket"></a> [s3\_access\_logging\_bucket](#module\_s3\_access\_logging\_bucket) | ../../modules/s3 | n/a |
| <a name="module_s3_app_log_bucket"></a> [s3\_app\_log\_bucket](#module\_s3\_app\_log\_bucket) | ../../modules/s3 | n/a |
| <a name="module_s3_app_log_bucket_notification"></a> [s3\_app\_log\_bucket\_notification](#module\_s3\_app\_log\_bucket\_notification) | ../../modules/s3_notification | n/a |
| <a name="module_s3_app_log_bucket_notification_1"></a> [s3\_app\_log\_bucket\_notification\_1](#module\_s3\_app\_log\_bucket\_notification\_1) | ../../modules/s3_notification | n/a |
| <a name="module_s3_iam_role"></a> [s3\_iam\_role](#module\_s3\_iam\_role) | ../../modules/iam | n/a |
| <a name="module_s3_waf_log_bucket"></a> [s3\_waf\_log\_bucket](#module\_s3\_waf\_log\_bucket) | ../../modules/s3 | n/a |
| <a name="module_s3_waf_log_bucket_notification"></a> [s3\_waf\_log\_bucket\_notification](#module\_s3\_waf\_log\_bucket\_notification) | ../../modules/s3_notification | n/a |
| <a name="module_waf_key"></a> [waf\_key](#module\_waf\_key) | ../../modules/kms | n/a |
| <a name="module_waf_resource"></a> [waf\_resource](#module\_waf\_resource) | ../../modules/waf_resource | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.trigger_codebuild_stack](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [random_id.server](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_uuid.test](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_managed_ap_activated"></a> [aws\_managed\_ap\_activated](#input\_aws\_managed\_ap\_activated) | aws\_managed\_ap\_activated | `bool` | n/a | yes |
| <a name="input_aws_managed_api_activated"></a> [aws\_managed\_api\_activated](#input\_aws\_managed\_api\_activated) | aws\_managed\_ap\_activated | `bool` | n/a | yes |
| <a name="input_aws_managed_crs_activated"></a> [aws\_managed\_crs\_activated](#input\_aws\_managed\_crs\_activated) | aws\_managed\_crs\_activated | `bool` | n/a | yes |
| <a name="input_aws_managed_ipr_activated"></a> [aws\_managed\_ipr\_activated](#input\_aws\_managed\_ipr\_activated) | aws\_managed\_ipr\_activated | `bool` | n/a | yes |
| <a name="input_aws_managed_kbi_activated"></a> [aws\_managed\_kbi\_activated](#input\_aws\_managed\_kbi\_activated) | aws\_managed\_kbi\_activated | `bool` | n/a | yes |
| <a name="input_aws_managed_linux_activated"></a> [aws\_managed\_linux\_activated](#input\_aws\_managed\_linux\_activated) | aws\_managed\_linux\_activated | `bool` | n/a | yes |
| <a name="input_aws_managed_php_activated"></a> [aws\_managed\_php\_activated](#input\_aws\_managed\_php\_activated) | aws\_managed\_php\_activated | `bool` | n/a | yes |
| <a name="input_aws_managed_posix_activated"></a> [aws\_managed\_posix\_activated](#input\_aws\_managed\_posix\_activated) | aws\_managed\_posix\_activated | `bool` | n/a | yes |
| <a name="input_aws_managed_sql_activated"></a> [aws\_managed\_sql\_activated](#input\_aws\_managed\_sql\_activated) | aws\_managed\_sql\_activated | `bool` | n/a | yes |
| <a name="input_aws_managed_windows_activated"></a> [aws\_managed\_windows\_activated](#input\_aws\_managed\_windows\_activated) | aws\_managed\_windows\_activated | `bool` | n/a | yes |
| <a name="input_aws_managed_wp_activated"></a> [aws\_managed\_wp\_activated](#input\_aws\_managed\_wp\_activated) | aws\_managed\_wp\_activated | `bool` | n/a | yes |
| <a name="input_cross_site_scripting_protection_activated"></a> [cross\_site\_scripting\_protection\_activated](#input\_cross\_site\_scripting\_protection\_activated) | cross\_site\_scripting\_protection\_activated | `bool` | n/a | yes |
| <a name="input_sql_injection_protection_activated"></a> [sql\_injection\_protection\_activated](#input\_sql\_injection\_protection\_activated) | sql\_injection\_protection\_activated | `bool` | n/a | yes |
| <a name="input_access_logging_bucket_name"></a> [access\_logging\_bucket\_name](#input\_access\_logging\_bucket\_name) | access\_logging\_bucket\_name | `string` | `null` | no |
| <a name="input_activate_aws_managed_rules_param"></a> [activate\_aws\_managed\_rules\_param](#input\_activate\_aws\_managed\_rules\_param) | activate\_aws\_managed\_rules\_param | `string` | `"no"` | no |
| <a name="input_activate_bad_bot_protection_param"></a> [activate\_bad\_bot\_protection\_param](#input\_activate\_bad\_bot\_protection\_param) | activate\_bad\_bot\_protection\_param | `string` | `"yes"` | no |
| <a name="input_activate_cross_site_scripting_protection_param"></a> [activate\_cross\_site\_scripting\_protection\_param](#input\_activate\_cross\_site\_scripting\_protection\_param) | activate\_cross\_site\_scripting\_protection\_param | `string` | `"yes"` | no |
| <a name="input_activate_http_flood_protection_param"></a> [activate\_http\_flood\_protection\_param](#input\_activate\_http\_flood\_protection\_param) | activate\_http\_flood\_protection\_param | `string` | `"yes - AWS WAF rate based rule"` | no |
| <a name="input_activate_reputation_lists_protection_param"></a> [activate\_reputation\_lists\_protection\_param](#input\_activate\_reputation\_lists\_protection\_param) | activate\_reputation\_lists\_protection\_param | `string` | `"yes"` | no |
| <a name="input_activate_scanners_probes_protection_param"></a> [activate\_scanners\_probes\_protection\_param](#input\_activate\_scanners\_probes\_protection\_param) | activate\_scanners\_probes\_protection\_param | `string` | `""` | no |
| <a name="input_activate_sql_injection_protection_param"></a> [activate\_sql\_injection\_protection\_param](#input\_activate\_sql\_injection\_protection\_param) | activate\_sql\_injection\_protection\_param | `string` | `"yes"` | no |
| <a name="input_api_stage"></a> [api\_stage](#input\_api\_stage) | api stage | `string` | `"ProdStage"` | no |
| <a name="input_app_access_log_bucket_logging_enabled"></a> [app\_access\_log\_bucket\_logging\_enabled](#input\_app\_access\_log\_bucket\_logging\_enabled) | app\_access\_log\_bucket\_logging\_enabled | `string` | `"no"` | no |
| <a name="input_athena_query_run_time_schedule_param"></a> [athena\_query\_run\_time\_schedule\_param](#input\_athena\_query\_run\_time\_schedule\_param) | athena\_query\_run\_time\_schedule\_param | `number` | `4` | no |
| <a name="input_bad_bot_protection_activated"></a> [bad\_bot\_protection\_activated](#input\_bad\_bot\_protection\_activated) | bad\_bot\_protection\_activated | `string` | `"yes"` | no |
| <a name="input_create_access_logging_bucket"></a> [create\_access\_logging\_bucket](#input\_create\_access\_logging\_bucket) | create\_access\_logging\_bucket | `string` | `"no"` | no |
| <a name="input_end_point"></a> [end\_point](#input\_end\_point) | cloudfront or ALB | `string` | `"cloudfront"` | no |
| <a name="input_error_threshold"></a> [error\_threshold](#input\_error\_threshold) | error threshold for Log Monitoring Settings | `number` | `50` | no |
| <a name="input_http_flood_athena_query_group_by_param"></a> [http\_flood\_athena\_query\_group\_by\_param](#input\_http\_flood\_athena\_query\_group\_by\_param) | http\_flood\_athena\_query\_group\_by\_param | `string` | `"None"` | no |
| <a name="input_ip_retention_period"></a> [ip\_retention\_period](#input\_ip\_retention\_period) | ip\_retention\_period | `string` | `"yes"` | no |
| <a name="input_ip_retention_period_allowed_param"></a> [ip\_retention\_period\_allowed\_param](#input\_ip\_retention\_period\_allowed\_param) | IP Retention Settings allowed value | `number` | `-1` | no |
| <a name="input_ip_retention_period_denied_param"></a> [ip\_retention\_period\_denied\_param](#input\_ip\_retention\_period\_denied\_param) | IP Retention Settings denied value | `number` | `-1` | no |
| <a name="input_keep_original_data"></a> [keep\_original\_data](#input\_keep\_original\_data) | S3 original data | `string` | `"No"` | no |
| <a name="input_key_prefix"></a> [key\_prefix](#input\_key\_prefix) | Keyprefix values for the lambda source code | `string` | `"security-automations-for-aws-waf"` | no |
| <a name="input_reputation_lists_protection_activated"></a> [reputation\_lists\_protection\_activated](#input\_reputation\_lists\_protection\_activated) | reputation\_lists\_protection\_activated | `string` | `"yes"` | no |
| <a name="input_request_threshold"></a> [request\_threshold](#input\_request\_threshold) | request threshold for Log Monitoring Settings | `number` | `100` | no |
| <a name="input_request_threshold_by_country_param"></a> [request\_threshold\_by\_country\_param](#input\_request\_threshold\_by\_country\_param) | request\_threshold\_by\_country\_param | `string` | `"no"` | no |
| <a name="input_resolve_count"></a> [resolve\_count](#input\_resolve\_count) | resolve\_count | `string` | `"yes"` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | retention\_in\_days | `number` | `365` | no |
| <a name="input_scanners_probes_protection_activated"></a> [scanners\_probes\_protection\_activated](#input\_scanners\_probes\_protection\_activated) | scanners\_probes\_protection\_activated | `string` | `"yes"` | no |
| <a name="input_send_anonymous_usage_data"></a> [send\_anonymous\_usage\_data](#input\_send\_anonymous\_usage\_data) | Data collection parameter | `string` | `"yes"` | no |
| <a name="input_sns_email_param"></a> [sns\_email\_param](#input\_sns\_email\_param) | SNS notification value | `string` | `""` | no |
| <a name="input_source_version"></a> [source\_version](#input\_source\_version) | version | `string` | `"v4.0.2"` | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | sse\_algorithm | `string` | `"aws:kms"` | no |
| <a name="input_user_agent_extra"></a> [user\_agent\_extra](#input\_user\_agent\_extra) | UserAgent | `string` | `"AwsSolution/-tf"` | no |
| <a name="input_user_defined_app_access_log_bucket_prefix"></a> [user\_defined\_app\_access\_log\_bucket\_prefix](#input\_user\_defined\_app\_access\_log\_bucket\_prefix) | user\_defined\_app\_access\_log\_bucket\_prefix | `string` | `"AWSLogs"` | no |
| <a name="input_waf_block_period"></a> [waf\_block\_period](#input\_waf\_block\_period) | block period for Log Monitoring Settings | `number` | `240` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->