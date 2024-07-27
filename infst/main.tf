# Define the AWS provider and set the region
provider "aws" {
  region = "eu-central-1"
}

# # Create an S3 bucket to host the front-end static website
# resource "aws_s3_bucket" "frontend_bucket" {
#   bucket = "my-frontend-bucket"  # Replace with your unique bucket name
#   acl    = "public-read"

#   website {
#     index_document = "index.html"
#     error_document = "error.html"
#   }
# }

# # # Create a CloudFront distribution for the S3 bucket
# resource "aws_cloudfront_distribution" "frontend_distribution" {
#   origin {
#     domain_name = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
#     origin_id   = "S3-my-frontend-bucket"

#     s3_origin_config {
#       origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
#     }
#   }

#   enabled             = true
#   is_ipv6_enabled     = true
#   comment             = "Front-end CloudFront Distribution"
#   default_root_object = "index.html"

#   aliases = ["www.example.com"]  # Replace with your domain name

#   default_cache_behavior {
#     allowed_methods  = ["GET", "HEAD"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = "S3-my-frontend-bucket"

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

#   viewer_certificate {
#     acm_certificate_arn = aws_acm_certificate.frontend_cert.arn
#     ssl_support_method  = "sni-only"
#   }
# }

# # Create a Route 53 hosted zone
# resource "aws_route53_zone" "main" {
#   name = "example.com"  # Replace with your domain name
# }

# # Create a Route 53 A record for the CloudFront distribution
# resource "aws_route53_record" "www" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "www"
#   type    = "A"

#   alias {
#     name                   = aws_cloudfront_distribution.frontend_distribution.domain_name
#     zone_id                = aws_cloudfront_distribution.frontend_distribution.hosted_zone_id
#     evaluate_target_health = false
#   }
# }

# # Create a VPC
# resource "aws_vpc" "main_vpc" {
#   cidr_block = "10.0.0.0/16"
# }

# # Create a public subnet within the VPC
# resource "aws_subnet" "public_subnet" {
#   vpc_id                  = aws_vpc.main_vpc.id
#   cidr_block              = "10.0.1.0/24"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "Public Subnet"
#   }
# }

# # Create a security group for the Application Load Balancer
# resource "aws_security_group" "alb_sg" {
#   name_prefix = "alb-sg-"

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Create a security group for the EC2 instances
# resource "aws_security_group" "ec2_sg" {
#   name_prefix = "ec2-sg-"

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Launch an EC2 instance
# resource "aws_instance" "backend_instance" {
#   ami                    = "ami-0c55b159cbfafe1f0"  # Replace with your desired AMI
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.public_subnet.id
#   security_groups        = [aws_security_group.ec2_sg.name]
#   associate_public_ip_address = true

#   user_data = <<-EOF
#               #!/bin/bash
#               yum update -y
#               amazon-linux-extras install docker
#               service docker start
#               usermod -a -G docker ec2-user
#               docker run -d -p 80:80 my-ecr-repo/my-container:latest
#               EOF

#   tags = {
#     Name = "Backend Instance"
#   }
# }

# # Create an Application Load Balancer
# resource "aws_lb" "app_lb" {
#   name               = "app-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = [aws_subnet.public_subnet.id]

#   enable_deletion_protection = false
# }

# # Create an HTTP listener for the ALB
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.app_lb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "forward"

#     target_group_arn = aws_lb_target_group.app_tg.arn
#   }
# }

# # Create a target group for the ALB
# resource "aws_lb_target_group" "app_tg" {
#   name     = "app-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main_vpc.id

#   health_check {
#     path                = "/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 5
#     unhealthy_threshold = 2
#     matcher             = "200"
#   }
# }

# # Attach EC2 instances to the target group
# resource "aws_lb_target_group_attachment" "app_tg_attachment" {
#   target_group_arn = aws_lb_target_group.app_tg.arn
#   target_id        = aws_instance.backend_instance.id
#   port             = 80
# }

# # Request an SSL certificate using AWS Certificate Manager
# resource "aws_acm_certificate" "frontend_cert" {
#   domain_name       = "example.com"  # Replace with your domain name
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }

#   tags = {
#     Name = "Frontend SSL Certificate"
#   }
# }

# # Validate the SSL certificate
# resource "aws_acm_certificate_validation" "frontend_cert_validation" {
#   certificate_arn         = aws_acm_certificate.frontend_cert.arn
#   validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
# }

# # Create a DNS record for certificate validation
# resource "aws_route53_record" "cert_validation" {
#   name    = aws_acm_certificate.frontend_cert.domain_validation_options[0].resource_record_name
#   type    = aws_acm_certificate.frontend_cert.domain_validation_options[0].resource_record_type
#   zone_id = aws_route53_zone.main.zone_id
#   records = [aws_acm_certificate.frontend_cert.domain_validation_options[0].resource_record_value]
#   ttl     = 60
# }

# # Output the S3 bucket name
# output "s3_bucket_name" {
#   value = aws_s3_bucket.frontend_bucket.bucket
# }

# # Output the CloudFront domain name
# output "cloudfront_domain_name" {
#   value = aws_cloudfront_distribution.frontend_distribution.domain_name
# }

# # Output the Route 53 hosted zone ID
# output "route53_zone_id" {
#   value = aws_route53_zone.main.zone_id
# }

# # Output the ALB DNS name
# output "alb_dns_name" {
#   value = aws_lb.app_lb.dns_name
# }