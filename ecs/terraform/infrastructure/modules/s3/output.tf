output "bucket_name" {
  value = local.name
}

output "bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}

