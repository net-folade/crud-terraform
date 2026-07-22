output "api_url" {
  description = "base url for the api gateway"
  value       = aws_api_gateway_stage.dev.invoke_url
}

output "table_name" {
  value = aws_dynamodb_table.readings.name
}