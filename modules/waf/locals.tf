locals {
  managed_rules = {
    rule1 = {
      name                                     = "AWS-AWSManagedRulesCommonRuleSet"
      priority                                 = 6
      managed_rule_group_statement_name        = "AWSManagedRulesCommonRuleSet"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "MetricForAMRCRS"
      deploy                                   = var.AWSManagedCRSActivated
    },
    rule2 = {
      name                                     = "AWS-AWSManagedRulesAdminProtectionRuleSet"
      priority                                 = 7
      managed_rule_group_statement_name        = "AWSManagedRulesAdminProtectionRuleSet"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "MetricForAMRAP"
      deploy                                   = var.AWSManagedAPActivated
    },
    rule3 = {
      name                                     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      priority                                 = 8
      managed_rule_group_statement_name        = "AWSManagedRulesKnownBadInputsRuleSet"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "MetricForAMRKBI"
      deploy                                   = var.AWSManagedKBIActivated
    },
    rule4 = {
      name                                     = "AWS-AWSManagedRulesAmazonIpReputationList"
      priority                                 = 2
      managed_rule_group_statement_name        = "AWSManagedRulesAmazonIpReputationList"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "MetricForAMRIPR"
      deploy                                   = var.AWSManagedIPRActivated
    },
    rule5 = {
      name                                     = "AWS-AWSManagedRulesAnonymousIpList"
      priority                                 = 4
      managed_rule_group_statement_name        = "AWSManagedRulesAnonymousIpList"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "MetricForAMRAIP"
      deploy                                   = var.AWSManagedAIPActivated
    },
    rule6 = {
      name                                     = "AWS-AWSManagedRulesSQLiRuleSet"
      priority                                 = 14
      managed_rule_group_statement_name        = "AWSManagedRulesSQLiRuleSet"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "MetricForAMRSQL"
      deploy                                   = var.AWSManagedSQLActivated
    },
    rule7 = {
      name                                     = "AWS-AWSManagedRulesLinuxRuleSet"
      priority                                 = 11
      managed_rule_group_statement_name        = "AWSManagedRulesLinuxRuleSet"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "MetricForAMRLinux"
      deploy                                   = var.AWSManagedLinuxActivated
    },
    rule8 = {
      name                                     = "AWS-AWSManagedRulesUnixRuleSet"
      priority                                 = 10
      managed_rule_group_statement_name        = "AWSManagedRulesUnixRuleSet"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "MetricForAMRPOSIX"
      deploy                                   = var.AWSManagedPOSIXActivated
    },
    rule9 = {
      name                                     = "AWS-AWSManagedRulesWindowsRuleSet"
      priority                                 = 9
      managed_rule_group_statement_name        = "AWSManagedRulesWindowsRuleSet"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "MetricForAMRWindows"
      deploy                                   = var.AWSManagedWindowsActivated
    },
    rule10 = {
      name                                     = "AWS-AWSManagedRulesPHPRuleSet"
      priority                                 = 12
      managed_rule_group_statement_name        = "AWSManagedRulesPHPRuleSet"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "MetricForAMRPHP"
      deploy                                   = var.AWSManagedPHPActivated
    },
    rule11 = {
      name                                     = "AWS-AWSManagedRulesWordPressRuleSet"
      priority                                 = 13
      managed_rule_group_statement_name        = "AWSManagedRulesWordPressRuleSet"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "MetricForAMRWP"
      deploy                                   = var.AWSManagedWPActivated
    }
  }
  or-statement-rules = {
    rule1 = {
      name        = "waf_whitelist_rule"
      priority    = 0
      metric_name = "MetricForWhitelistRule"
      deploy      = true
      arn-v4      = var.WhitelistSetV4_arn
      arn-v6      = var.WhitelistSetV6_arn
    },
    rule2 = {
      name        = "waf_blacklist_rule"
      priority    = 1
      metric_name = "MetricForBlacklistRule"
      deploy      = true
      arn-v4      = var.WAFBlacklistSetV4_arn
      arn-v6      = var.WAFBlacklistSetV6_arn
    },
    rule3 = {
      name        = "http_flood_regular_rule"
      priority    = 18
      metric_name = "MetricForHttpFloodRegularRule"
      deploy      = var.HttpFloodProtectionLogParserActivated
      arn-v4      = var.HttpFloodSetIPV4arn
      arn-v6      = var.HttpFloodSetIPV6arn
    },
    rule4 = {
      name        = "scanners_and_probes_rule"
      priority    = 17
      metric_name = "MetricForScannersProbesRule"
      deploy      = var.ScannersProbesProtectionActivated
      arn-v4      = var.WAFScannersProbesSetV4_arn
      arn-v6      = var.WAFScannersProbesSetV6_arn
    },
    rule5 = {
      name        = "ip_reputation_lists_rule"
      priority    = 3
      metric_name = "MetricForIPReputationListsRule"
      deploy      = var.ReputationListsProtectionActivated
      arn-v4      = var.WAFReputationListsSetV4_arn
      arn-v6      = var.WAFReputationListsSetV6_arn
    },
    rule6 = {
      name        = "bad_bot_rule"
      priority    = 5
      metric_name = "MetricForBadBotRule"
      deploy      = true
      arn-v4      = var.WAFBadBotSetV4_arn
      arn-v6      = var.WAFBadBotSetV6_arn
    }
  }
  rate-statement-rules = {
    rule1 = {
      name             = "http-flood-rate-based-rule"
      priority         = 19
      metric_name      = "MetricForHttpFloodRateBasedRule"
      deploy           = var.HttpFloodProtectionRateBasedRuleActivated
      RequestThreshold = var.RequestThreshold
    }
  }
  sql-statement-rules = {
    rule1 = {
      name        = "sql-based-rule"
      priority    = 15
      metric_name = "MetricForsqlBasedRule"
      deploy      = var.SqlInjectionProtectionActivated
    }
  }
  xss-rules = {
    rule1 = {
      name        = "xss-rule"
      priority    = 16
      metric_name = "MetricForxssrule"
      deploy      = var.CrossSiteScriptingProtectionActivated
    }
  }
}