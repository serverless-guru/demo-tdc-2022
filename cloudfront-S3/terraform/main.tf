locals {
  domain_name_parts = split(".", var.domain_name)
  domain_name_tld   = join(".", slice(local.domain_name_parts, 1, length(local.domain_name_parts)))

  tags = merge(var.tags,
    {
      Terraform = true
      Service   = "cloudfront-s3"
      CreatedBy = var.created_by
  })
}

############################
# Data
############################
data "aws_route53_zone" "selected" {
  name = "${local.domain_name_tld}."
}


