#IPV4 sets

resource "random_id" "ipset" {
  byte_length = 8
}

resource "aws_wafv2_ip_set" "WAFWhitelistSetV4" {
  count              = var.create_ipset ? 1 : 0
  name               = "waf_whitelist_set_v41_${random_id.ipset.hex}"
  description        = "Block Bad Bot IPV4 addresses"
  scope              = var.SCOPE
  ip_address_version = "IPV4"
  addresses          = []
}

resource "aws_wafv2_ip_set" "WAFBlacklistSetV4" {
  count              = var.create_ipset ? 1 : 0
  name               = "waf_blacklist_set_v41_${random_id.ipset.hex}"
  description        = "Block Bad Bot IPV6 addresses"
  scope              = var.SCOPE
  ip_address_version = "IPV4"
  addresses          = []
}

resource "aws_wafv2_ip_set" "WAFBadBotSetV4" {
  count              = var.create_ipset && var.BadBotProtectionActivated == "yes" ? 1 : 0
  name               = "waf_badbot_set_v41_${random_id.ipset.hex}"
  description        = "Block Bad Bot IPV4 addresses"
  scope              = var.SCOPE
  ip_address_version = "IPV4"
  addresses          = []
}

resource "aws_wafv2_ip_set" "WAFReputationListsSetV4" {
  count              = var.create_ipset && var.ReputationListsProtectionActivated == "yes" ? 1 : 0
  name               = "waf_reputationlists_setV41_${random_id.ipset.hex}"
  description        = "Block Reputation List IPV4 addresses"
  scope              = var.SCOPE
  ip_address_version = "IPV4"
  addresses          = []
  lifecycle {
    ignore_changes = [
      addresses
    ]
  }
}

resource "aws_wafv2_ip_set" "WAFHttpFloodSetV4" {
  count              = var.create_ipset ? 1 : 0
  name               = "waf_httpflood_set_v41_${random_id.ipset.hex}"
  description        = "Block HTTP Flood IPV4 addresses"
  scope              = var.SCOPE
  ip_address_version = "IPV4"
  addresses          = []
}

resource "aws_wafv2_ip_set" "WAFScannersProbesSetV4" {
  count              = var.create_ipset && var.ScannersProbesProtectionActivated == "yes" ? 1 : 0
  name               = "waf_scannersprobes_set_v41_${random_id.ipset.hex}"
  description        = "Block HTTP Flood IPV4 addresses"
  scope              = var.SCOPE
  ip_address_version = "IPV4"
  addresses          = []
}

#IPV6 sets

resource "aws_wafv2_ip_set" "WAFWhitelistSetV6" {
  count              = var.create_ipset ? 1 : 0
  name               = "waf_whitelist_set_v61_${random_id.ipset.hex}"
  description        = "Block Bad Bot IPV4 addresses"
  scope              = var.SCOPE
  ip_address_version = "IPV4"
  addresses          = []
}

resource "aws_wafv2_ip_set" "WAFBlacklistSetV6" {
  count              = var.create_ipset ? 1 : 0
  name               = "waf_blacklist_set_v61_${random_id.ipset.hex}"
  description        = "Block Bad Bot IPV6 addresses"
  scope              = var.SCOPE
  ip_address_version = "IPV6"
  addresses          = []
}

resource "aws_wafv2_ip_set" "WAFBadBotSetV6" {
  count              = var.create_ipset && var.BadBotProtectionActivated == "yes" ? 1 : 0
  name               = "waf_badbot_set_v61_${random_id.ipset.hex}"
  description        = "Block Bad Bot IPV6 addresses"
  scope              = var.SCOPE
  ip_address_version = "IPV6"
  addresses          = []
}

resource "aws_wafv2_ip_set" "WAFReputationListsSetV6" {
  count              = var.create_ipset && var.ReputationListsProtectionActivated == "yes" ? 1 : 0
  name               = "waf_reputationlists_set_V61_${random_id.ipset.hex}"
  description        = "Block Reputation List IPV6 addresses"
  scope              = var.SCOPE
  ip_address_version = "IPV6"
  addresses          = []
  lifecycle {
    ignore_changes = [
      addresses
    ]
  }
}

resource "aws_wafv2_ip_set" "WAFHttpFloodSetV6" {
  count              = var.create_ipset ? 1 : 0
  name               = "waf_httpflood_set_v61_${random_id.ipset.hex}"
  description        = "Block HTTP Flood IPV6 addresses"
  scope              = var.SCOPE
  ip_address_version = "IPV6"
  addresses          = []
}

resource "aws_wafv2_ip_set" "WAFScannersProbesSetV6" {
  count              = var.create_ipset && var.ScannersProbesProtectionActivated == "yes" ? 1 : 0
  name               = "waf_scannersprobes_set_v61_${random_id.ipset.hex}"
  description        = "Block HTTP Flood IPV6 addresses"
  scope              = var.SCOPE
  ip_address_version = "IPV6"
  addresses          = []
}