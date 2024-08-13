# Reference the existing Route 53 hosted zone
data "aws_route53_zone" "main" {
  name = var.root_domain_name # Replace with your domain name
}

# Create A/ALIAS record for root domain
resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.root_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.prod_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.prod_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# Create subdomain for dev environment
resource "aws_route53_record" "dev" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "dev.${var.root_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.dev_distribution.domain_name]
}

# Create DNS records for RDS
resource "aws_route53_record" "rds_subdomain" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "rds.dev-vysh.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.app_lb.dns_name]
}

# Create DNS records for Redis
resource "aws_route53_record" "redis_subdomain" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "redis.dev-vysh.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.app_lb.dns_name]
}


# Create DNS records for RDS
resource "aws_route53_record" "rdsdev_subdomain" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "rdsdev.dev-vysh.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.app_lb.dns_name]
}

# Create DNS records for Redis
resource "aws_route53_record" "redisdev_subdomain" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "redisdev.dev-vysh.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.app_lb.dns_name]
}