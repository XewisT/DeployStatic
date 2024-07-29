resource "aws_acm_certificate" "site_cert" {
  provider          = aws.us_east_1
  domain_name       = var.root_domain_name
  subject_alternative_names = ["*.${var.root_domain_name}"]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "site_cert_dns" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.site_cert.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.site_cert.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.site_cert.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.main.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "site_cert_validation" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.site_cert.arn
  validation_record_fqdns = [aws_route53_record.site_cert_dns.fqdn]
}


# Request an ACM certificate
resource "aws_acm_certificate" "app_cert" {
  domain_name       = var.root_domain_name # Replace with your domain
  validation_method = "DNS"
  
  tags = {
    Name = "app-cert"
  }
}
