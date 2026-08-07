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
  default     = "dev"
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention for the Lambda log group."
  type        = number
  default     = 7
}
