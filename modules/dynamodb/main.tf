resource "aws_dynamodb_table" "this" {
  #checkov:skip=CKV_AWS_119: "Ensure DynamoDB Tables are encrypted using a KMS Customer Managed CMK. All user data stored in Amazon DynamoDB is fully encrypted at rest"
  name             = var.name
  billing_mode     = var.billing_mode
  hash_key         = var.hash_key
  range_key        = var.range_key
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type

  ttl {
    enabled        = var.ttl_enabled
    attribute_name = var.ttl_attribute_name
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  dynamic "attribute" {
    for_each = var.attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  server_side_encryption {
    enabled     = var.server_side_encryption_enabled
    kms_key_arn = var.server_side_encryption_kms_key_arn
  }
}