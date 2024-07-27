# Reference the existing Route 53 hosted zone
data "aws_route53_zone" "main" {
  name = var.root_domain_name # Replace with your domain name
}

# Create a Route 53 A record for the CloudFront distribution
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "dev-vysh.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.frontend_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.frontend_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
