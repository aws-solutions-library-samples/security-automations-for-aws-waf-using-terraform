data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "this" {
  description = var.description
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Id" : "key-default-1",
      "Statement" : [{
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:GenerateDataKey*",
          "kms:Get*",
          "kms:Delete*",
          "kms:ScheduleKeyDeletion",
          "kms:ListAliases",
          "kms:CreateGrant",
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:CancelKeyDeletion"
        ],
        "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Principal" : { "Service" : "logs.${data.aws_region.current.name}.amazonaws.com" },
          "Action" : [
            "kms:Encrypt*",
            "kms:Decrypt*",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:Describe*"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
  enable_key_rotation = var.enable_key_rotation
}