resource "aws_wafv2_web_acl" "WafAcl" {
  count       = var.create_waf_rule ? 1 : 0
  name        = var.WafAcl_name
  description = "Custom WAFWebACL"
  scope       = "CLOUDFRONT"
  default_action {
    allow {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf_web_acl_metric"
    sampled_requests_enabled   = true
  }
  dynamic "rule" {
    for_each = {
      for key, value in local.managed_rules : key => value
      if value.deploy == true || value.deploy == "yes"
    }
    content {
      name     = rule.value.name
      priority = rule.value.priority
      override_action {
        none {}
      }
      statement {
        managed_rule_group_statement {
          name        = rule.value.managed_rule_group_statement_name
          vendor_name = rule.value.managed_rule_group_statement_vendor_name
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.metric_name
        sampled_requests_enabled   = true
      }
    }
  }
  dynamic "rule" {
    for_each = {
      for key, value in local.or-statement-rules : key => value
      if value.deploy == true
    }
    content {
      name     = rule.value.name
      priority = rule.value.priority
      action {
        block {}
      }
      statement {
        or_statement {
          statement {
            ip_set_reference_statement {
              arn = rule.value.arn-v4
            }
          }
          statement {
            ip_set_reference_statement {
              arn = rule.value.arn-v6
            }
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.metric_name
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic "rule" {
    for_each = {
      for key, value in local.rate-statement-rules : key => value
      if value.deploy == true
    }
    content {
      name     = rule.value.name
      priority = rule.value.priority
      action {
        block {}
      }
      statement {
        rate_based_statement {
          aggregate_key_type = "IP"
          limit              = rule.value.RequestThreshold
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.metric_name
        sampled_requests_enabled   = true
      }
    }
  }
  dynamic "rule" {
    for_each = {
      for key, value in local.sql-statement-rules : key => value
      if value.deploy == true
    }
    content {
      name     = rule.value.name
      priority = rule.value.priority
      action {
        block {}
      }
      statement {
        or_statement {
          statement {
            sqli_match_statement {
              field_to_match {
                query_string {}
              }
              text_transformation {
                priority = 1
                type     = "URL_DECODE"
              }

              text_transformation {
                priority = 2
                type     = "HTML_ENTITY_DECODE"
              }
            }
          }
          statement {
            sqli_match_statement {
              field_to_match {
                body {}
              }
              text_transformation {
                priority = 1
                type     = "URL_DECODE"
              }

              text_transformation {
                priority = 2
                type     = "HTML_ENTITY_DECODE"
              }
            }
          }
          statement {
            sqli_match_statement {
              field_to_match {
                uri_path {}
              }
              text_transformation {
                priority = 1
                type     = "URL_DECODE"
              }

              text_transformation {
                priority = 2
                type     = "HTML_ENTITY_DECODE"
              }
            }
          }
          statement {
            sqli_match_statement {
              field_to_match {
                single_header {
                  name = "authorization"
                }
              }
              text_transformation {
                priority = 1
                type     = "URL_DECODE"
              }

              text_transformation {
                priority = 2
                type     = "HTML_ENTITY_DECODE"
              }
            }
          }
          statement {
            sqli_match_statement {
              field_to_match {
                single_header {
                  name = "cookie"
                }
              }
              text_transformation {
                priority = 1
                type     = "URL_DECODE"
              }

              text_transformation {
                priority = 2
                type     = "HTML_ENTITY_DECODE"
              }
            }
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.metric_name
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic "rule" {
    for_each = {
      for key, value in local.xss-rules : key => value
      if value.deploy == true
    }
    content {
      name     = rule.value.name
      priority = rule.value.priority
      action {
        block {}
      }
      statement {
        or_statement {
          statement {
            xss_match_statement {
              field_to_match {
                query_string {}
              }
              text_transformation {
                priority = 1
                type     = "URL_DECODE"
              }
              text_transformation {
                priority = 2
                type     = "HTML_ENTITY_DECODE"
              }
            }
          }
          statement {
            xss_match_statement {
              field_to_match {
                body {}
              }
              text_transformation {
                priority = 1
                type     = "URL_DECODE"
              }

              text_transformation {
                priority = 2
                type     = "HTML_ENTITY_DECODE"
              }
            }
          }
          statement {
            xss_match_statement {
              field_to_match {
                uri_path {}
              }
              text_transformation {
                priority = 1
                type     = "URL_DECODE"
              }

              text_transformation {
                priority = 2
                type     = "HTML_ENTITY_DECODE"
              }
            }
          }
          statement {
            xss_match_statement {
              field_to_match {
                single_header {
                  name = "cookie"
                }
              }
              text_transformation {
                priority = 1
                type     = "URL_DECODE"
              }

              text_transformation {
                priority = 2
                type     = "HTML_ENTITY_DECODE"
              }
            }
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.metric_name
        sampled_requests_enabled   = true
      }
    }
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "example" {
  count                   = var.HttpFloodProtectionLogParserActivated == "yes" ? 1 : 0
  log_destination_configs = [var.firehouse_arn]
  resource_arn            = aws_wafv2_web_acl.WafAcl[0].arn
}