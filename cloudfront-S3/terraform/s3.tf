module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.3.0"

  bucket        = var.domain_name
  acl           = "public-read"
  force_destroy = true
  website = {
    index_document = "index.html"
    error_document = "404.html"
  }
  tags = local.tags
}
