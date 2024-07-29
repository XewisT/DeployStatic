# Reference the existing Route 53 hosted zone
data "aws_route53_zone" "main" {
  name = var.root_domain_name # Replace with your domain name
}

# Create subdomain for prod environment
resource "aws_route53_record" "prod" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "prod.${var.root_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.prod_distribution.domain_name]
}

# Create subdomain for dev environment
resource "aws_route53_record" "dev" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "dev.${var.root_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.dev_distribution.domain_name]
}