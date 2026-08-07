variable "role_name" {
  description = "Full name of the Lambda execution role. Composed by the caller."
  type        = string
}

variable "policy_name" {
  description = "Full name of the customer-managed DynamoDB access policy. Composed by the caller."
  type        = string
}

variable "table_arn" {
  description = "ARN of the DynamoDB table the Lambda may read and write. Scopes the policy."
  type        = string
}

variable "tags" {
  description = "Tags applied to the role and policy."
  type        = map(string)
  default     = {}
}
