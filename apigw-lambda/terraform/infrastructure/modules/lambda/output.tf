output "arn" {
  value       = aws_lambda_function.lambda.arn
  description = "The ARN of the lambda function"
}

output "name" {
  value       = local.name
  description = "The name of the function"
}
