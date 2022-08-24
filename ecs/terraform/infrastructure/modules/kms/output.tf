output "alias_arn" {
  value = aws_kms_alias.alias.arn
}

output "alias_target_key_arn" {
  value = aws_kms_alias.alias.target_key_arn
}

output "alias_name" {
  value = aws_kms_alias.alias.name
}

output "target_key_arn" {
  value = aws_kms_key.key.arn
}