output "function_name" {
  description = "Name of the Lambda function."
  value       = aws_lambda_function.api.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function."
  value       = aws_lambda_function.api.arn
}

output "invoke_arn" {
  description = "Invocation ARN used by the API Gateway AWS_PROXY integration."
  value       = aws_lambda_function.api.invoke_arn
}

output "log_group_name" {
  description = "CloudWatch log group backing the function."
  value       = aws_cloudwatch_log_group.lambda.name
}
