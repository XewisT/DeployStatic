# # Define the CloudFront Origin Access Identity
# resource "aws_cloudfront_origin_access_identity" "oai" {
#   comment = "OAI for S3 buckets"
# }

# # Create a CloudFront distribution for the prod environment
# resource "aws_cloudfront_distribution" "prod_distribution" {
#   origin {
#     domain_name = aws_s3_bucket.prod_bucket.bucket_regional_domain_name
#     origin_id   = "S3-prod-bucket"

#     s3_origin_config {
#       origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
#     }
#   }

#  origin {
#     domain_name = aws_lb.app_lb.dns_name
#     origin_id   = "ALB-prod"

#     custom_origin_config {
#       http_port                = 80
#       https_port               = 443
#       origin_protocol_policy   = "https-only"
#       origin_ssl_protocols     = ["TLSv1.2"]
#     }
#   }

#   enabled             = true
#   is_ipv6_enabled     = true
#   comment             = "Prod CloudFront Distribution"
#   default_root_object = "index.html"

#   aliases = ["prod.dev-vysh.com"]  

#   default_cache_behavior {
#     allowed_methods  = ["GET", "HEAD"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = "S3-prod-bucket"

#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }

#     viewer_protocol_policy = "redirect-to-https"
#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     acm_certificate_arn = aws_acm_certificate.site_cert.arn
#     ssl_support_method  = "sni-only"
#   }
# }

# Define the CloudFront Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for S3 buckets"
}

# Create a CloudFront distribution for the prod environment
resource "aws_cloudfront_distribution" "prod_distribution" {
  origin {
    domain_name = aws_s3_bucket.prod_bucket.bucket_regional_domain_name
    origin_id   = "S3-prod-bucket"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_lb.app_lb.dns_name
    origin_id   = "ALB-prod"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Prod CloudFront Distribution"
  default_root_object = "index.html"

  aliases = ["prod.dev-vysh.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-prod-bucket"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern     = "/test_connection/rds"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ALB-prod"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  ordered_cache_behavior {
    path_pattern     = "/test_connection/redis"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ALB-prod"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.site_cert.arn
    ssl_support_method  = "sni-only"
  }
}



# Create a CloudFront distribution for the dev environment
resource "aws_cloudfront_distribution" "dev_distribution" {
  origin {
    domain_name = aws_s3_bucket.dev_bucket.bucket_regional_domain_name
    origin_id   = "S3-dev-bucket"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Dev CloudFront Distribution"
  default_root_object = "index.html"

  aliases = ["dev.dev-vysh.com"]  

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-dev-bucket"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.site_cert.arn
    ssl_support_method  = "sni-only"
  }
}