# Output the S3 bucket name
output "prod_bucket_name" {
  value = aws_s3_bucket.prod_bucket.bucket
}

output "dev_bucket_name" {
  value = aws_s3_bucket.dev_bucket.bucket
}

# Output the CloudFront domain name
output "cloudfront_prod_domain_name" {
  value = aws_cloudfront_distribution.prod_distribution.domain_name
}

# Output the CloudFront domain name
output "cloudfront_dev_domain_name" {
  value = aws_cloudfront_distribution.dev_distribution.domain_name
}

# Output the ALB DNS name
output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}

output "route53_zone_id" {
  value = data.aws_route53_zone.main.zone_id
}

output "s3_bucket_id" {
  value = aws_s3_bucket_website_configuration.prod_bucket_website.website_domain
}