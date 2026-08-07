variable "api_name" {
  description = "Full name of the REST API. Composed by the caller."
  type        = string
}

variable "stage_name" {
  description = "Deployment stage name. Appears in the invoke URL."
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda to grant invoke permission to."
  type        = string
}

variable "lambda_invoke_arn" {
  description = "Lambda invoke ARN used as the AWS_PROXY integration URI."
  type        = string
}

variable "throttling_rate_limit" {
  description = "Steady-state requests per second. null skips the method settings resource entirely."
  type        = number
  default     = null
}

variable "throttling_burst_limit" {
  description = "Burst capacity. Only read when throttling_rate_limit is set."
  type        = number
  default     = null
}

variable "tags" {
  description = "Tags applied to the REST API and stage."
  type        = map(string)
  default     = {}
}
