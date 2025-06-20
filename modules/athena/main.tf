resource "aws_athena_workgroup" "default" {
  name        = var.name
  description = var.description
  state       = var.state
  configuration {
    publish_cloudwatch_metrics_enabled = var.publish_cloudwatch_metrics_enabled

    result_configuration {
      encryption_configuration {
        encryption_option = var.workgroup_encryption_option
        kms_key_arn       = var.kms_key_arn
      }
      output_location = var.output_location
    }
  }

  force_destroy = var.workgroup_force_destroy
}