output "remove_expired_role_arn" {
  description = "arn value of the IAM role"
  value       = try(module.remove_expired_ip_iam_role[0].role_arn, null)
}