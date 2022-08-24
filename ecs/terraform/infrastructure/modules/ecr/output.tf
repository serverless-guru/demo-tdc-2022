output "repository_url" {
  value       = aws_ecr_repository.repository.repository_url
  description = "The url of the ECR Repository"
}
