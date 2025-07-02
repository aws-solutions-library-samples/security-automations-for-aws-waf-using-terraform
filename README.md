# 🛡️ Security Automations for AWS WAF - Terraform

[![License: MIT-0](https://img.shields.io/badge/License-MIT--0-yellow.svg)](https://github.com/aws/mit-0)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.0.7-623CE4.svg)](https://terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-4.x-FF9900.svg)](https://registry.terraform.io/providers/hashicorp/aws/latest)

> **⚠️ Important Notice**: This is sample code for demonstration purposes. Do not use in production environments without proper testing, security review, and customization for your specific requirements.

## 🚀 What This Solution Does

This Terraform-based solution automatically deploys a comprehensive set of **AWS WAF (Web Application Firewall)** rules that protect your web applications from common attacks including:

- 🔒 **SQL Injection** attacks
- 🕷️ **Cross-Site Scripting (XSS)** attempts  
- 🤖 **Bad bot** traffic and scrapers
- 🌊 **HTTP flood** attacks (DDoS protection)
- 🎯 **Scanner and probe** activities
- 📋 **Reputation-based** IP blocking

### Key Benefits

✅ **One-Click Deployment** - Deploy enterprise-grade WAF protection in minutes  
✅ **Cost-Effective** - Automated rules reduce manual security management overhead  
✅ **Scalable** - Works with both CloudFront and Application Load Balancers  
✅ **Intelligent** - Uses machine learning and threat intelligence for dynamic protection  
✅ **Observable** - Built-in CloudWatch dashboards and logging  

## 🏗️ Architecture Overview

![Target architecture diagram](https://user-images.githubusercontent.com/111126012/184378602-b8feebb5-e5db-41d9-a296-0580d21f73fc.png)

The solution creates a multi-layered security architecture that includes:
- **AWS WAF** with intelligent rule sets
- **Lambda functions** for log analysis and IP management
- **Amazon Athena** for advanced log querying
- **S3 buckets** for secure log storage
- **CloudWatch** dashboards for monitoring
- **SNS notifications** for security alerts

## 🎯 Who Should Use This

- **DevOps Engineers** setting up web application security
- **Security Teams** implementing automated threat protection  
- **Cloud Architects** designing secure web infrastructures
- **Developers** protecting applications from common web attacks

## ⚡ Quick Start

### Prerequisites

Before you begin, ensure you have:

- ✅ **AWS Account** with appropriate permissions
- ✅ **AWS CLI** installed and configured ([Setup Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html))
- ✅ **Terraform** >= 1.0.7 installed ([Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli))

### 🚀 Deploy in 3 Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd security-automations-for-aws-waf-using-terraform
   ```

2. **Navigate to the basic example**
   ```bash
   cd examples/basic
   ```

3. **Deploy with Terraform**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

That's it! Your WAF protection is now active. 🎉

### 🎛️ Configuration Options

The solution supports two deployment targets:

| Target | Description | Use Case |
|--------|-------------|----------|
| **CloudFront** | Global CDN protection | Static websites, global applications |
| **Application Load Balancer** | Regional protection | Dynamic applications, APIs |

## 🔧 Protection Features

### Core Security Rules

| Protection Type | Description | Default Status |
|----------------|-------------|----------------|
| **SQL Injection** | Blocks malicious SQL queries | ✅ Enabled |
| **Cross-Site Scripting** | Prevents XSS attacks | ✅ Enabled |
| **HTTP Flood Protection** | Rate-based DDoS protection | ✅ Enabled |
| **Bad Bot Protection** | Blocks malicious crawlers | ✅ Enabled |
| **Scanner Protection** | Detects reconnaissance attempts | ✅ Enabled |
| **Reputation Lists** | IP-based threat intelligence | ✅ Enabled |

### Advanced Features

- **🔄 Automatic IP Management** - Dynamic blocking and allowlisting
- **📊 Real-time Analytics** - CloudWatch dashboards and metrics
- **🚨 Alert System** - SNS notifications for security events
- **🗂️ Log Analysis** - Automated parsing with Lambda and Athena
- **⏰ Configurable Retention** - Customizable IP blocking periods

## 📋 Configuration Parameters

### Essential Settings

| Parameter | Description | Default | Options |
|-----------|-------------|---------|---------|
| `end_point` | Deployment target | `cloudfront` | `cloudfront`, `ALB` |
| `activate_http_flood_protection_param` | DDoS protection method | `yes - AWS WAF rate based rule` | See [HTTP Flood Options](#http-flood-options) |
| `sns_email_param` | Email for security alerts | `""` | Your email address |

### HTTP Flood Protection Options

- `yes – AWS Lambda log parser` - Advanced analysis with custom logic
- `yes – Amazon Athena log parser` - SQL-based log analysis  
- `yes – AWS WAF rate-based rule` - Built-in rate limiting (recommended)

## 📊 Monitoring and Observability

After deployment, you'll have access to:

- **📈 CloudWatch Dashboard** - Real-time security metrics
- **📧 Email Alerts** - Immediate notification of threats
- **🗃️ Centralized Logging** - All WAF logs in S3
- **🔍 Athena Queries** - Advanced log analysis capabilities

## 🚨 Known Issues & Solutions

### WAFv2 IPSet Deletion Error

**Issue**: `WAFOptimisticLockException` during `terraform destroy`

**Solution**: 
```bash
# Manually delete IPSets in AWS Console, then retry
terraform destroy
```

**Reference**: [Terraform AWS Provider Issue #21136](https://github.com/hashicorp/terraform-provider-aws/issues/21136)

## 🔄 Alternative Deployment Methods

### CloudFormation Option

For CloudFormation deployment, see the official AWS solution:
[Security Automations for AWS WAF](https://docs.aws.amazon.com/solutions/latest/security-automations-for-aws-waf/solution-overview.html)

### Custom Implementation

Create your own configuration by referencing the modules:
```hcl
module "waf_security" {
  source = "path/to/this/module"
  
  # Your custom configuration
  end_point = "ALB"
  activate_http_flood_protection_param = "yes - AWS Lambda log parser"
  sns_email_param = "security@yourcompany.com"
}
```

## 💰 Cost Considerations

This solution incurs costs for:
- AWS WAF requests and rules
- Lambda function executions
- S3 storage for logs
- CloudWatch logs and metrics
- Athena query processing

Use the [AWS Pricing Calculator](https://calculator.aws) to estimate costs for your specific usage patterns.

## 🔒 Security Best Practices

- **🔐 Least Privilege**: Use IAM roles with minimal required permissions
- **🔄 Regular Updates**: Keep Terraform and AWS provider versions current
- **📝 Monitoring**: Set up CloudWatch alarms for unusual activity
- **🧪 Testing**: Test WAF rules in a staging environment first
- **📋 Documentation**: Document any custom rule modifications

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for:
- How to report issues
- Development guidelines  
- Security vulnerability reporting

## 📄 License

This project is licensed under the **MIT-0 License** - see the [LICENSE](LICENSE) file for details.

---

## 📚 Technical Documentation

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
| <a name="module_dashboard"></a> [dashboard](#module\_dashboard) | ./modules/cloudwatch | n/a |
| <a name="module_firehouse_athena_source"></a> [firehouse\_athena\_source](#module\_firehouse\_athena\_source) | ./modules/firehose_athena_source | n/a |
| <a name="module_ip_retention_resource"></a> [ip\_retention\_resource](#module\_ip\_retention\_resource) | ./modules/ip_retention_resource | n/a |
| <a name="module_ip_sets"></a> [ip\_sets](#module\_ip\_sets) | ./modules/waf | n/a |
| <a name="module_s3_access_logging_bucket"></a> [s3\_access\_logging\_bucket](#module\_s3\_access\_logging\_bucket) | ./modules/s3 | n/a |
| <a name="module_s3_app_log_bucket"></a> [s3\_app\_log\_bucket](#module\_s3\_app\_log\_bucket) | ./modules/s3 | n/a |
| <a name="module_s3_app_log_bucket_notification"></a> [s3\_app\_log\_bucket\_notification](#module\_s3\_app\_log\_bucket\_notification) | ./modules/s3_notification | n/a |
| <a name="module_s3_app_log_bucket_notification_1"></a> [s3\_app\_log\_bucket\_notification\_1](#module\_s3\_app\_log\_bucket\_notification\_1) | ./modules/s3_notification | n/a |
| <a name="module_s3_iam_role"></a> [s3\_iam\_role](#module\_s3\_iam\_role) | ./modules/iam | n/a |
| <a name="module_s3_waf_log_bucket"></a> [s3\_waf\_log\_bucket](#module\_s3\_waf\_log\_bucket) | ./modules/s3 | n/a |
| <a name="module_s3_waf_log_bucket_notification"></a> [s3\_waf\_log\_bucket\_notification](#module\_s3\_waf\_log\_bucket\_notification) | ./modules/s3_notification | n/a |
| <a name="module_waf_key"></a> [waf\_key](#module\_waf\_key) | ./modules/kms | n/a |
| <a name="module_waf_resource"></a> [waf\_resource](#module\_waf\_resource) | ./modules/waf_resource | n/a |

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
| <a name="input_aws_managed_ap_activated"></a> [aws\_managed\_ap\_activated](#input\_aws\_managed\_ap\_activated) | Enable AWS Managed Rules for Anonymous Proxy | `bool` | n/a | yes |
| <a name="input_aws_managed_api_activated"></a> [aws\_managed\_api\_activated](#input\_aws\_managed\_api\_activated) | Enable AWS Managed Rules for API Gateway | `bool` | n/a | yes |
| <a name="input_aws_managed_crs_activated"></a> [aws\_managed\_crs\_activated](#input\_aws\_managed\_crs\_activated) | Enable AWS Managed Core Rule Set | `bool` | n/a | yes |
| <a name="input_aws_managed_ipr_activated"></a> [aws\_managed\_ipr\_activated](#input\_aws\_managed\_ipr\_activated) | Enable AWS Managed IP Reputation Rules | `bool` | n/a | yes |
| <a name="input_aws_managed_kbi_activated"></a> [aws\_managed\_kbi\_activated](#input\_aws\_managed\_kbi\_activated) | Enable AWS Managed Known Bad Inputs Rules | `bool` | n/a | yes |
| <a name="input_aws_managed_linux_activated"></a> [aws\_managed\_linux\_activated](#input\_aws\_managed\_linux\_activated) | Enable AWS Managed Linux Operating System Rules | `bool` | n/a | yes |
| <a name="input_aws_managed_php_activated"></a> [aws\_managed\_php\_activated](#input\_aws\_managed\_php\_activated) | Enable AWS Managed PHP Application Rules | `bool` | n/a | yes |
| <a name="input_aws_managed_posix_activated"></a> [aws\_managed\_posix\_activated](#input\_aws\_managed\_posix\_activated) | Enable AWS Managed POSIX Operating System Rules | `bool` | n/a | yes |
| <a name="input_aws_managed_sql_activated"></a> [aws\_managed\_sql\_activated](#input\_aws\_managed\_sql\_activated) | Enable AWS Managed SQL Database Rules | `bool` | n/a | yes |
| <a name="input_aws_managed_windows_activated"></a> [aws\_managed\_windows\_activated](#input\_aws\_managed\_windows\_activated) | Enable AWS Managed Windows Operating System Rules | `bool` | n/a | yes |
| <a name="input_aws_managed_wp_activated"></a> [aws\_managed\_wp\_activated](#input\_aws\_managed\_wp\_activated) | Enable AWS Managed WordPress Application Rules | `bool` | n/a | yes |
| <a name="input_cross_site_scripting_protection_activated"></a> [cross\_site\_scripting\_protection\_activated](#input\_cross\_site\_scripting\_protection\_activated) | Enable Cross-Site Scripting (XSS) protection | `bool` | n/a | yes |
| <a name="input_sql_injection_protection_activated"></a> [sql\_injection\_protection\_activated](#input\_sql\_injection\_protection\_activated) | Enable SQL Injection protection | `bool` | n/a | yes |
| <a name="input_access_logging_bucket_name"></a> [access\_logging\_bucket\_name](#input\_access\_logging\_bucket\_name) | Name of existing S3 bucket for access logging | `string` | `null` | no |
| <a name="input_activate_aws_managed_rules_param"></a> [activate\_aws\_managed\_rules\_param](#input\_activate\_aws\_managed\_rules\_param) | Activate AWS Managed Rules | `string` | `"no"` | no |
| <a name="input_activate_bad_bot_protection_param"></a> [activate\_bad\_bot\_protection\_param](#input\_activate\_bad\_bot\_protection\_param) | Activate bad bot protection | `string` | `"yes"` | no |
| <a name="input_activate_cross_site_scripting_protection_param"></a> [activate\_cross\_site\_scripting\_protection\_param](#input\_activate\_cross\_site\_scripting\_protection\_param) | Activate Cross-Site Scripting protection | `string` | `"yes"` | no |
| <a name="input_activate_http_flood_protection_param"></a> [activate\_http\_flood\_protection\_param](#input\_activate\_http\_flood\_protection\_param) | HTTP flood protection method | `string` | `"yes - AWS WAF rate based rule"` | no |
| <a name="input_activate_reputation_lists_protection_param"></a> [activate\_reputation\_lists\_protection\_param](#input\_activate\_reputation\_lists\_protection\_param) | Activate reputation lists protection | `string` | `"yes"` | no |
| <a name="input_activate_scanners_probes_protection_param"></a> [activate\_scanners\_probes\_protection\_param](#input\_activate\_scanners\_probes\_protection\_param) | Activate scanners and probes protection | `string` | `""` | no |
| <a name="input_activate_sql_injection_protection_param"></a> [activate\_sql\_injection\_protection\_param](#input\_activate\_sql\_injection\_protection\_param) | Activate SQL injection protection | `string` | `"yes"` | no |
| <a name="input_api_stage"></a> [api\_stage](#input\_api\_stage) | API Gateway stage name | `string` | `"ProdStage"` | no |
| <a name="input_app_access_log_bucket_logging_enabled"></a> [app\_access\_log\_bucket\_logging\_enabled](#input\_app\_access\_log\_bucket\_logging\_enabled) | Enable application access log bucket logging | `string` | `"no"` | no |
| <a name="input_athena_query_run_time_schedule_param"></a> [athena\_query\_run\_time\_schedule\_param](#input\_athena\_query\_run\_time\_schedule\_param) | Athena query runtime schedule in hours | `number` | `4` | no |
| <a name="input_bad_bot_protection_activated"></a> [bad\_bot\_protection\_activated](#input\_bad\_bot\_protection\_activated) | Enable bad bot protection | `string` | `"yes"` | no |
| <a name="input_create_access_logging_bucket"></a> [create\_access\_logging\_bucket](#input\_create\_access\_logging\_bucket) | Create new access logging bucket | `string` | `"no"` | no |
| <a name="input_end_point"></a> [end\_point](#input\_end\_point) | Deployment target: CloudFront or Application Load Balancer | `string` | `"cloudfront"` | no |
| <a name="input_error_threshold"></a> [error\_threshold](#input\_error\_threshold) | Error threshold for log monitoring | `number` | `50` | no |
| <a name="input_http_flood_athena_query_group_by_param"></a> [http\_flood\_athena\_query\_group\_by\_param](#input\_http\_flood\_athena\_query\_group\_by\_param) | HTTP flood Athena query group by parameter | `string` | `"None"` | no |
| <a name="input_ip_retention_period"></a> [ip\_retention\_period](#input\_ip\_retention\_period) | Enable IP retention period management | `string` | `"yes"` | no |
| <a name="input_ip_retention_period_allowed_param"></a> [ip\_retention\_period\_allowed\_param](#input\_ip\_retention\_period\_allowed\_param) | IP retention period for allowed IPs (minutes, -1 for permanent) | `number` | `-1` | no |
| <a name="input_ip_retention_period_denied_param"></a> [ip\_retention\_period\_denied\_param](#input\_ip\_retention\_period\_denied\_param) | IP retention period for denied IPs (minutes, -1 for permanent) | `number` | `-1` | no |
| <a name="input_keep_original_data"></a> [keep\_original\_data](#input\_keep\_original\_data) | Keep original data in S3 | `string` | `"No"` | no |
| <a name="input_key_prefix"></a> [key\_prefix](#input\_key\_prefix) | S3 key prefix for Lambda source code | `string` | `"security-automations-for-aws-waf"` | no |
| <a name="input_reputation_lists_protection_activated"></a> [reputation\_lists\_protection\_activated](#input\_reputation\_lists\_protection\_activated) | Enable reputation lists protection | `string` | `"yes"` | no |
| <a name="input_request_threshold"></a> [request\_threshold](#input\_request\_threshold) | Request threshold for log monitoring | `number` | `100` | no |
| <a name="input_request_threshold_by_country_param"></a> [request\_threshold\_by\_country\_param](#input\_request\_threshold\_by\_country\_param) | Enable request threshold by country | `string` | `"no"` | no |
| <a name="input_resolve_count"></a> [resolve\_count](#input\_resolve\_count) | Enable resolve count functionality | `string` | `"yes"` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Log retention period in days | `number` | `365` | no |
| <a name="input_scanners_probes_protection_activated"></a> [scanners\_probes\_protection\_activated](#input\_scanners\_probes\_protection\_activated) | Enable scanners and probes protection | `string` | `"yes"` | no |
| <a name="input_send_anonymous_usage_data"></a> [send\_anonymous\_usage\_data](#input\_send\_anonymous\_usage\_data) | Send anonymous usage data to AWS | `string` | `"yes"` | no |
| <a name="input_sns_email_param"></a> [sns\_email\_param](#input\_sns\_email\_param) | Email address for SNS notifications | `string` | `""` | no |
| <a name="input_source_version"></a> [source\_version](#input\_source\_version) | Source code version | `string` | `"v4.0.2"` | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | S3 server-side encryption algorithm | `string` | `"aws:kms"` | no |
| <a name="input_user_agent_extra"></a> [user\_agent\_extra](#input\_user\_agent\_extra) | Additional user agent string | `string` | `"AwsSolution/SO0006-tf"` | no |
| <a name="input_user_defined_app_access_log_bucket_prefix"></a> [user\_defined\_app\_access\_log\_bucket\_prefix](#input\_user\_defined\_app\_access\_log\_bucket\_prefix) | Custom prefix for application access logs | `string` | `"AWSLogs"` | no |
| <a name="input_waf_block_period"></a> [waf\_block\_period](#input\_waf\_block\_period) | WAF block period in minutes | `number` | `240` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_access_log_bucket"></a> [app\_access\_log\_bucket](#output\_app\_access\_log\_bucket) | Name of Application Access Log S3 Bucket |
| <a name="output_bad_bot_honey_end_point"></a> [bad\_bot\_honey\_end\_point](#output\_bad\_bot\_honey\_end\_point) | URL of bad bot honey pot endpoint |
| <a name="output_badbot_honeyendpoint"></a> [badbot\_honeyendpoint](#output\_badbot\_honeyendpoint) | URL of bad bot honey pot endpoint |
| <a name="output_badbot_ipv4_name"></a> [badbot\_ipv4\_name](#output\_badbot\_ipv4\_name) | Name of bad bot IPv4 IP set |
| <a name="output_waf_acl_arn"></a> [waf\_acl\_arn](#output\_waf\_acl\_arn) | ARN of the WAF Web ACL |
| <a name="output_waf_log_bucket"></a> [waf\_log\_bucket](#output\_waf\_log\_bucket) | Name of WAF Log S3 Bucket |
| <a name="output_waf_web_acl"></a> [waf\_web\_acl](#output\_waf\_web\_acl) | Name of the WAF Web ACL |
<!-- END_TF_DOCS -->
