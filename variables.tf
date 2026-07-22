variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "table_name" {
  description = "DynamoDB table storing device readings"
  type        = string
  default     = "iot-tracker"
}

variable "function_name" {
  description = "Lambda function handling crud operations"
  type        = string
  default     = "iot-tracker-lambda"
}