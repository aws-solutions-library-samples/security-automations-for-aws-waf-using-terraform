# ----------------------------------------------------------------------------------------------------------------------
# CloudWatch Dashboard
# ----------------------------------------------------------------------------------------------------------------------

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_dashboard" "Main" {
  count          = var.create_dashboard ? 1 : 0
  dashboard_name = "monitoringDashboard_${data.aws_region.current.name}"

  dashboard_body = jsonencode(
    {
      "widgets" : [
        {
          "type" : "metric",
          "x" : 0,
          "y" : 0,
          "width" : 15,
          "height" : 10,
          "properties" : {
            "metrics" : [
              ["AWS/WAFV2", "BlockedRequests", "WebACL", "WAFWebACLMetric", "Rule", "ALL", "Region", "${data.aws_region.current.name}"],
              ["AWS/WAFV2", "AllowedRequests", "WebACL", "WAFWebACLMetric", "Rule", "ALL", "Region", "${data.aws_region.current.name}"]
              # ["AWS/WAFV2", "BlockedRequests", "WebACL", "${module.waf_resource[count.index].waf_acl_name}", "Rule", "ALL", "Region", "${data.aws_region.current.name}"],
              # ["AWS/WAFV2", "AllowedRequests", "WebACL", "${module.waf_resource[count.index].waf_acl_name}", "Rule", "ALL", "Region", "${data.aws_region.current.name}"]
            ],
            "view" : "timeSeries",
            "stacked" : false,
            "stat" : "Sum",
            "period" : 300,
            "region" : "${data.aws_region.current.name}"
          }
        }
      ]
    }
  )
}
