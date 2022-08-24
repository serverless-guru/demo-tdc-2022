output "name" {
  value = local.name
}

output "arn" {
  value = aws_iam_user.iam_user.arn
}
