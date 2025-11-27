# CloudFront distributions use special hosted zone id
data "aws_route53_zone" "primary" {
  name         = var.zone_name   # example: "example.com"
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.domain_name      # e.g. "www.example.com"
  type    = "A"

  alias {
    name                   = module.s3_cloudfront.cloudfront_domain_name
    zone_id                = module.s3_cloudfront.cloudfront_hosted_zone_id # or use aws_cloudfront_distribution.cdn.hosted_zone_id output
    evaluate_target_health = false
  }
}

# For apex (example.com), create A alias too:
resource "aws_route53_record" "apex" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.zone_root      # e.g. "example.com"
  type    = "A"

  alias {
    name                   = module.s3_cloudfront.cloudfront_domain_name
    zone_id                = module.s3_cloudfront.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

