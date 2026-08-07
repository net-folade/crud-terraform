variable "table_name" {
  description = "Full name of the table. Composed by the caller — this module does not build names."
  type        = string
}

variable "deletion_protection_enabled" {
  description = "AWS-side delete protection. Blocks DeleteTable regardless of who calls it."
  type        = bool
  default     = false
}

variable "prevent_destroy" {
  description = "Terraform-side destroy guardrail. Selects the lifecycle-protected copy of the table."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to the table."
  type        = map(string)
  default     = {}
}
