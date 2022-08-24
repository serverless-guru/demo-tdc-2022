output "arn" {
  value       = aws_dynamodb_table.table.arn
  description = "The ARN of the DynamoDB Table"
}
output "name" {
  value       = aws_dynamodb_table.table.name
  description = "The ARN of the DynamoDB Table"
}

output "stream_arn" {
  value       = var.stream_enabled ? aws_dynamodb_table.table.stream_arn : null
  description = "The ARN of the Stream"
}
