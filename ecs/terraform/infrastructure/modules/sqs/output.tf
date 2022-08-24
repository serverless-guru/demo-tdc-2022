output "arn" {
  value       = aws_sqs_queue.queue.arn
  description = "The ARN of the SQS Queue"
}

output "url" {
  // shouldn't this be just aws_sqs_queue.queue.id
  // see here https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue#attributes-reference
  value       = "https://sqs.${var.region}.amazonaws.com/${data.aws_caller_identity.current.account_id}/${aws_sqs_queue.queue.name}"
  description = "The URL of the SQS Queue"
}

output "name" {
  value       = aws_sqs_queue.queue.name
  description = "The name of the SQS Queue"
}
