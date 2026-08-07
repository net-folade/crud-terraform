output "api_url" {
  description = "Base URL for the API Gateway stage."
  value       = module.api.invoke_url
}

output "table_name" {
  description = "DynamoDB table holding readings."
  value       = module.dynamodb.table_name
}

output "function_name" {
  description = "Lambda function serving the API."
  value       = module.lambda.function_name
}
