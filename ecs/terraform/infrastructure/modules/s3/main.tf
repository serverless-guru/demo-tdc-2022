data "aws_caller_identity" "current" {}

locals {
  name = "${var.name}-${var.stage}"
  tags = merge(var.tags,
    {
      Name = local.name
  })
}

resource "aws_s3_bucket" "bucket" {
  bucket = local.name
  acl    = var.acl

  lifecycle_rule {
    enabled = true

    transition {
      days          = 30
      storage_class = "INTELLIGENT_TIERING"
    }

    dynamic "expiration" {
      for_each = var.expire > 0 ? [var.expire] : []
      content {
        days = var.expire
      }
    }
  }

  tags = local.tags
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
