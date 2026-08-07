variable "function_name" {
  description = "Full name of the Lambda function. Composed by the caller."
  type        = string
}

variable "role_arn" {
  description = "ARN of an existing execution role. This module creates no IAM resources."
  type        = string
}

variable "table_name" {
  description = "DynamoDB table name, passed to the handler as the TABLE_NAME environment variable."
  type        = string
}

variable "source_file" {
  description = "Absolute or root-relative path to the handler source file to package."
  type        = string
}

variable "build_output_path" {
  description = "Path the generated deployment zip is written to."
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention for the function's log group."
  type        = number
  default     = 7
}

variable "reserved_concurrent_executions" {
  description = "Reserved concurrency ceiling. null leaves the function unreserved."
  type        = number
  default     = null
}

variable "tags" {
  description = "Tags applied to the function and its log group."
  type        = map(string)
  default     = {}
}
