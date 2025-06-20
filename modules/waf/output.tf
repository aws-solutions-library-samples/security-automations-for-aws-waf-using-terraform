output "waf_acl_arn" {
  description = "The aws_iam_role object."
  value       = try(aws_wafv2_web_acl.WafAcl[0].arn, null)
}

output "waf_acl_name" {
  description = "The WAF name object."
  value       = try(aws_wafv2_web_acl.WafAcl[0].name, null)
}

output "WAFWhitelistSetV4_arn" {
  description = "arn value of the ipsets"
  value       = try(aws_wafv2_ip_set.WAFWhitelistSetV4[0].arn, null)
}

output "WAFWhitelistSetV6_arn" {
  description = "arn value of the ipsets"
  value       = try(aws_wafv2_ip_set.WAFWhitelistSetV6[0].arn, null)
}

output "WAFBlacklistSetV4_arn" {
  description = "arn value of the blacklist ipsets"
  value       = try(aws_wafv2_ip_set.WAFBlacklistSetV4[0].arn, null)
}

output "WAFBlacklistSetV6_arn" {
  description = "arn value of the blacklist ipsets"
  value       = try(aws_wafv2_ip_set.WAFBlacklistSetV6[0].arn, null)
}

output "WAFScannersProbesSetV4_arn" {
  description = "arn value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFScannersProbesSetV4[0].arn, null)
}

output "WAFScannersProbesSetV6_arn" {
  description = "arn value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFScannersProbesSetV6[0].arn, null)
}

output "WAFReputationListsSetV4_arn" {
  description = "arn value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFReputationListsSetV4[0].arn, null)
}

output "WAFReputationListsSetV6_arn" {
  description = "arn value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFReputationListsSetV6[0].arn, null)
}

output "WAFBadBotSetV4_arn" {
  description = "arn value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFBadBotSetV4[0].arn, null)
}

output "WAFBadBotSetV6_arn" {
  description = "arn value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFBadBotSetV6[0].arn, null)
}

output "WAFHttpFloodSetV4_arn" {
  description = "arn value of the http flood ipsets"
  value       = try(aws_wafv2_ip_set.WAFHttpFloodSetV4[0].arn, null)
}

output "WAFHttpFloodSetV6_arn" {
  description = "arn value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFHttpFloodSetV6[0].arn, null)
}

####ID outputs

output "WAFWhitelistSetV4_id" {
  description = "id value of the ipsets"
  value       = try(aws_wafv2_ip_set.WAFWhitelistSetV4[0].id, null)
}

output "WAFWhitelistSetV6_id" {
  description = "id value of the ipsets"
  value       = try(aws_wafv2_ip_set.WAFWhitelistSetV6[0].id, null)
}

output "WAFBlacklistSetV4_id" {
  description = "id value of the blacklist ipsets"
  value       = try(aws_wafv2_ip_set.WAFBlacklistSetV4[0].id, null)
}

output "WAFBlacklistSetV6_id" {
  description = "id value of the blacklist ipsets"
  value       = try(aws_wafv2_ip_set.WAFBlacklistSetV6[0].id, null)
}

output "WAFScannersProbesSetV4_id" {
  description = "id value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFScannersProbesSetV4[0].id, null)
}

output "WAFScannersProbesSetV6_id" {
  description = "id value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFScannersProbesSetV6[0].id, null)
}

output "WAFReputationListsSetV4_id" {
  description = "id value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFReputationListsSetV4[0].id, null)
}

output "WAFReputationListsSetV6_id" {
  description = "id value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFReputationListsSetV6[0].id, null)
}

output "WAFBadBotSetV4_id" {
  description = "id value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFBadBotSetV4[0].id, null)
}

output "WAFBadBotSetV6_id" {
  description = "id value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFBadBotSetV6[0].id, null)
}

output "WAFHttpFloodSetV4_id" {
  description = "id value of the http flood ipsets"
  value       = try(aws_wafv2_ip_set.WAFHttpFloodSetV4[0].id, null)
}

output "WAFHttpFloodSetV6_id" {
  description = "id value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFHttpFloodSetV6[0].id, null)
}


###name

output "WAFWhitelistSetV4_name" {
  description = "name value of the ipsets"
  value       = try(aws_wafv2_ip_set.WAFWhitelistSetV4[0].name, null)
}

output "WAFWhitelistSetV6_name" {
  description = "name value of the ipsets"
  value       = try(aws_wafv2_ip_set.WAFWhitelistSetV6[0].name, null)
}

output "WAFBlacklistSetV4_name" {
  description = "name value of the blacklist ipsets"
  value       = try(aws_wafv2_ip_set.WAFBlacklistSetV4[0].name, null)
}

output "WAFBlacklistSetV6_name" {
  description = "name value of the blacklist ipsets"
  value       = try(aws_wafv2_ip_set.WAFBlacklistSetV6[0].name, null)
}

output "WAFScannersProbesSetV4_name" {
  description = "name value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFScannersProbesSetV4[0].name, null)
}

output "WAFScannersProbesSetV6_name" {
  description = "name value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFScannersProbesSetV6[0].name, null)
}

output "WAFReputationListsSetV4_name" {
  description = "name value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFReputationListsSetV4[0].name, null)
}

output "WAFReputationListsSetV6_name" {
  description = "name value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFReputationListsSetV6[0].name, null)
}

output "WAFBadBotSetV4_name" {
  description = "name value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFBadBotSetV4[0].name, null)
}

output "WAFBadBotSetV6_name" {
  description = "name value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFBadBotSetV6[0].name, null)
}

output "WAFHttpFloodSetV4_name" {
  description = "name value of the http flood ipsets"
  value       = try(aws_wafv2_ip_set.WAFHttpFloodSetV4[0].name, null)
}

output "WAFHttpFloodSetV6_name" {
  description = "name value of the scannerprobes ipsets"
  value       = try(aws_wafv2_ip_set.WAFHttpFloodSetV6[0].name, null)
}