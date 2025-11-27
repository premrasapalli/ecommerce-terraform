variable "project_name" { type = string }
variable "domain_name"  { type = string, default = "" }
variable "tags"         { type = map(string) }

resource "aws_s3_bucket" "assets" {
  bucket = "${var.project_name}-assets-${random_id.suffix.hex}"
  acl    = "private"

  versioning { enabled = true }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.tags
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.project_name} assets"
}

# Bucket policy to allow CloudFront OAI only
resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.assets.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowCloudFrontServicePrincipalReadOnly"
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
        }
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.assets.arn}/*"
      }
    ]
  })
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"

  aliases = var.domain_name != "" ? [var.domain_name] : []

  origin {
    domain_name = aws_s3_bucket.assets.bucket_regional_domain_name
    origin_id   = "s3-${aws_s3_bucket.assets.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET","HEAD","OPTIONS"]
    cached_methods   = ["GET","HEAD"]
    target_origin_id = "s3-${aws_s3_bucket.assets.id}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  price_class = "PriceClass_100"
  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    # Use ACM cert in us-east-1 and reference its ARN here; create that cert from below
    acm_certificate_arn            = var.cloudflare_acm_arn # pass cert ARN when used with custom domain
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  tags = var.tags
}

output "bucket_name" {
  value = aws_s3_bucket.assets.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "cloudfront_id" {
  value = aws_cloudfront_distribution.cdn.id
}

