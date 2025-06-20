output "role_arn" {
  description = "arn value of the IAM role"
  value       = try(aws_iam_role.role.arn, null)
}

output "role_name" {
  description = "Name of the IAM role"
  value       = try(aws_iam_role.role.name, null)
}
