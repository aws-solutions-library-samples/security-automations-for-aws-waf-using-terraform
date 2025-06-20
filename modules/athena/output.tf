output "athena_workgroup_name" {
  description = "Athena workgroup."
  value       = aws_athena_workgroup.default.name
}