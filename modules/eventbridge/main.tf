resource "aws_cloudwatch_event_rule" "trigger" {
  count               = var.create_event_rule ? 1 : 0
  name                = var.name
  description         = var.description
  schedule_expression = var.frequency_type
  is_enabled          = var.enabled
  event_pattern       = try(var.event_pattern, null)
}

resource "aws_cloudwatch_event_target" "target" {
  count     = var.create_event_rule ? 1 : 0
  arn       = var.target_arn
  rule      = aws_cloudwatch_event_rule.trigger[count.index].name
  target_id = var.target_id
  input     = try(var.input, null)
}

resource "aws_lambda_permission" "this" {
  count          = var.create_lambda_invoke_permission ? 1 : 0
  action         = "lambda:InvokeFunction"
  function_name  = var.function_name
  principal      = var.permission_principal
  source_account = var.permission_source_account == "" ? null : var.permission_source_account
  source_arn     = length(aws_cloudwatch_event_rule.trigger) != 0 ? "${aws_cloudwatch_event_rule.trigger[count.index].arn}" : "${var.permission_source_arn}"
}