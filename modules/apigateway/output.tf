output "apigateway_arn" {
  description = "api gateway arn"
  value       = try(aws_api_gateway_rest_api.this.arn, null)
}

output "rest_api_id" {
  description = "REST API id"
  value       = try(aws_api_gateway_rest_api.this.id, null)
}