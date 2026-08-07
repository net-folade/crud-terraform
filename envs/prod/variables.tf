variable "region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project slug, first component of every resource name."
  type        = string
  default     = "iot-tracker"
}

variable "environment" {
  description = "Environment name. Suffixes every resource name and names the API stage."
  type        = string
  default     = "prod"
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention for the Lambda log group."
  type        = number
  default     = 30
}

variable "reserved_concurrent_executions" {
  description = "Reserved concurrency ceiling for the Lambda."
  type        = number
  default     = 10
}

variable "throttling_rate_limit" {
  description = "Steady-state requests per second at the API Gateway stage."
  type        = number
  default     = 50
}

variable "throttling_burst_limit" {
  description = "Burst capacity at the API Gateway stage."
  type        = number
  default     = 100
}
