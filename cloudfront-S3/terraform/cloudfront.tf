data "aws_cloudfront_cache_policy" "CachingOptimized" {
  name = "Managed-CachingOptimized"
}

module "cloudfront" {
  depends_on = [
    module.bucket
  ]
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "2.9.3"

  aliases          = [var.domain_name]
  comment          = var.domain_name
  enabled          = true
  is_ipv6_enabled  = true
  price_class      = "PriceClass_All"
  retain_on_delete = false

  tags = local.tags

  origin = {
    siteS3Bucket = {
      domain_name = module.bucket.s3_bucket_website_endpoint
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }
  default_cache_behavior = {
    target_origin_id       = "siteS3Bucket"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods      = ["GET", "HEAD", "OPTIONS"]
    cache_policy_id      = data.aws_cloudfront_cache_policy.CachingOptimized.id
    use_forwarded_values = false
    compress             = true
  }
  viewer_certificate = {
    acm_certificate_arn      = aws_acm_certificate.website.id
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
}
