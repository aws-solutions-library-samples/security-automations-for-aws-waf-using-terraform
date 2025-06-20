variable "role_name" {
  type        = string
  description = "Role name"
  default     = ""
}

variable "policy_name" {
  type        = string
  description = "policy name"
  default     = ""
}

variable "assume_role_principals" {
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
