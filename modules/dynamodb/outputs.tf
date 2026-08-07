# Exactly one table block exists at a time; concat + one() collapses them safely.

output "table_name" {
  description = "Name of the readings table."
  value       = one(concat(aws_dynamodb_table.this[*].name, aws_dynamodb_table.protected[*].name))
}

output "table_arn" {
  description = "ARN of the readings table, for IAM policy scoping."
  value       = one(concat(aws_dynamodb_table.this[*].arn, aws_dynamodb_table.protected[*].arn))
}
