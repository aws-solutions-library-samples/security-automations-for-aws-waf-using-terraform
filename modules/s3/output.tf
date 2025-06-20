output "bucket_arn" {
  description = "The aws_iam_role object."
  value       = try(aws_s3_bucket.this.arn, null)
}

output "bucket_name" {
  description = "The aws_iam_role object."
  value       = try(aws_s3_bucket.this.bucket, null)
}

output "bucket_id" {
  description = "The aws_iam_role object."
  value       = try(aws_s3_bucket.this.id, null)
}