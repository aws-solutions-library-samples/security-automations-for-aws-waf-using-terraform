resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

    actions = var.assume_role_actions

    dynamic "principals" {
      for_each = var.assume_role_principals

      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }
    dynamic "condition" {
      for_each = var.assume_role_conditions

      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

data "aws_iam_policy_document" "policy" {

  dynamic "statement" {
    for_each = var.policy_statements

    content {
      sid           = try(statement.value.sid, null)
      effect        = try(statement.value.effect, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      resources     = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_role_policy" "policy" {
  #checkov:skip=CKV_AWS_288: "Ensured IAM policies does not allow data exfiltration"
  #checkov:skip=CKV_AWS_355: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions. The solutions doesn’t use “*” unless it is required by AWS service APIs."
  name   = var.policy_name
  policy = data.aws_iam_policy_document.policy.json
  role   = aws_iam_role.role.name
}