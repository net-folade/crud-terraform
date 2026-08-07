output "invoke_url" {
  description = "Base URL for the deployed stage."
  value       = aws_api_gateway_stage.this.invoke_url
}

output "rest_api_id" {
  description = "ID of the REST API."
  value       = aws_api_gateway_rest_api.api.id
}

output "stage_name" {
  description = "Name of the deployed stage."
  value       = aws_api_gateway_stage.this.stage_name
}

output "execution_arn" {
  description = "Execution ARN of the REST API, for scoping additional invoke permissions."
  value       = aws_api_gateway_rest_api.api.execution_arn
}
