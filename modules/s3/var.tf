variable "bucket" {
  description = "(Optional, Forces new resource) The name of the bucket. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "acl" {
  description = "(Optional) The canned ACL to apply. Conflicts with `grant`"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "versioning" {
  description = "Map containing versioning configuration."
  type        = map(string)
  default     = {}
}


variable "server_side_encryption_configuration" {
  description = "Map containing server-side encryption configuration."
  type        = any
  default     = {}
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "bucket_Principal" {
  type = set(object({
    type        = string
    identifiers = list(string)
  }))
  description = "(Required if assume_role_policy is not set) Principals for the assume role policy."
  default     = []
}

variable "assume_role_conditions" {
  type = set(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  description = "(Optional) Conditions for the assume role policy."
  default     = []
}

variable "assume_role_actions" {
  type        = set(string)
  description = "(Required if assume_role_policy is not set) Actions for the assume role policy."
  default     = ["sts:AssumeRole"]
}

# inline policy

variable "policy_statements" {
  type        = any
  description = "(Optional) List of IAM policy statements to attach to the User as an inline policy."
  default     = []
}

variable "rolename" {
  type    = string
  default = null
}

variable "logging" {
  description = "Map containing access bucket logging configuration."
  type        = map(string)
  default     = {}
}