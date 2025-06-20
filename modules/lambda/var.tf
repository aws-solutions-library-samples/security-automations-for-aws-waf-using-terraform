# Required variables.

variable "function_name" {
  type    = string
  default = ""
}

variable "handler" {
  type    = string
  default = ""
}

variable "runtime" {
  type    = string
  default = ""
}

variable "source_path" {
  description = "The absolute path to a local file or directory containing your Lambda source code"
  type        = string
  default     = ""
}

# Optional variables specific to this module.

variable "build_command" {
  description = "The command to run to create the Lambda package zip file"
  type        = string
  default     = "python build.py '$filename' '$runtime' '$source'"
}

variable "build_paths" {
  description = "The files or directories used by the build command, to trigger new Lambda package builds whenever build scripts change"
  type        = list(string)
  default     = ["build.py"]
}

variable "cloudwatch_logs" {
  description = "Set this to false to disable logging your Lambda output to CloudWatch Logs"
  type        = bool
  default     = true
}

variable "lambda_at_edge" {
  description = "Set this to true if using Lambda@Edge, to enable publishing, limit the timeout, and allow edgelambda.amazonaws.com to invoke the function"
  type        = bool
  default     = false
}

variable "policy" {
  description = "An additional policy to attach to the Lambda function role"
  type = object({
    json = string
  })
  default = null
}

variable "trusted_entities" {
  description = "Lambda function additional trusted entities for assuming roles (trust relationship)"
  type        = list(string)
  default     = []
}

locals {
  publish = var.lambda_at_edge ? true : var.publish
  timeout = var.lambda_at_edge ? min(var.timeout, 5) : var.timeout
}

# Optional attributes to pass through to the resource.

variable "description" {
  type    = string
  default = null
}

variable "layers" {
  type    = list(string)
  default = null
}

variable "kms_key_arn" {
  type    = string
  default = null
}

variable "memory_size" {
  type    = number
  default = null
}

variable "publish" {
  type    = bool
  default = false
}
variable "reserved_concurrent_executions" {
  type    = number
  default = null
}

variable "tags" {
  type    = map(string)
  default = null
}

variable "timeout" {
  type    = number
  default = 3
}

variable "s3_bucket" {
  type    = string
  default = ""
}

variable "s3_key" {
  type    = string
  default = ""
}

variable "role_arn" {
  type    = string
  default = ""
}

# Optional blocks to pass through to the resource.

variable "dead_letter_config" {
  type = object({
    target_arn = string
  })
  default = null
}

variable "environment" {
  type = object({
    variables = map(string)
  })
  default = null
}

variable "tracing_config" {
  type = object({
    mode = string
  })
  default = null
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "create_lambda_invoke_permission" {
  type    = string
  default = false
}

variable "create_lambda" {
  type    = string
  default = false
}

variable "permission_principal" {
  type    = string
  default = ""
}

variable "permission_source_arn" {
  type    = string
  default = null
}

variable "permission_source_account" {
  type    = string
  default = ""
}

variable "retention_in_days" {
  type    = number
  default = 365
}