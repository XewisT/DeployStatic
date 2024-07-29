# # Create an Application Load Balancer
# resource "aws_lb" "app_lb" {
#   name               = "app-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

#   enable_deletion_protection = false
# }

# # Create an HTTP listener for the ALB
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.app_lb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#       type = "redirect"

#       redirect {
#         port        = "443"
#         protocol    = "HTTPS"
#         status_code = "HTTP_301"
#       }
#     }
# }

# # Add a listener for HTTPS (port 443)
# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.app_lb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08" # You can choose an appropriate SSL policy

#   certificate_arn = aws_acm_certificate.app_cert.arn # Replace with your ACM certificate ARN

#   default_action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.prod_app_tg_8001.arn
#   }
# }

# # Create a target group for port 8001 Prod
# resource "aws_lb_target_group" "prod_app_tg_8001" {
#   name     = "app-tg-8001-prod"
#   port     = 8001
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main_vpc.id

#   health_check {
#     path                = "/test_connection/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 5
#     unhealthy_threshold = 2
#     matcher             = "200"
#   }
# }
# Create a target group for port 8002 Prod
# resource "aws_lb_target_group" "prod_app_tg_8002" {
#   name     = "app-tg-8002-prod"
#   port     = 8002
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main_vpc.id

#   health_check {
#     path                = "/test_connection/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 5
#     unhealthy_threshold = 2
#     matcher             = "200"
#   }
# }

# # Create a target group for port 8001 Dev
# resource "aws_lb_target_group" "dev_app_tg_8001" {
#   name     = "app-tg-8001-dev"
#   port     = 8001
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main_vpc.id

#   health_check {
#     path                = "/test_connection/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 5
#     unhealthy_threshold = 2
#     matcher             = "200"
#   }
# }




# Create an Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  enable_deletion_protection = false
}

# Create an HTTP listener for the ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Add a listener for HTTPS (port 443)
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" # You can choose an appropriate SSL policy

  certificate_arn = aws_acm_certificate.app_cert.arn # Replace with your ACM certificate ARN

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.prod_app_tg_8001.arn
  }
}

# Create a target group for port 8001 Prod
resource "aws_lb_target_group" "prod_app_tg_8001" {
  name     = "app-tg-8001-prod"
  port     = 8001
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    path                = "/test_connection/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Create a target group for port 8002 Prod
resource "aws_lb_target_group" "prod_app_tg_8002" {
  name     = "app-tg-8002-prod"
  port     = 8002
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    path                = "/test_connection/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Create a rule to forward to port 8001 target group
resource "aws_lb_listener_rule" "https_rule_8001" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.prod_app_tg_8001.arn
  }

  condition {
    path_pattern {
      values = ["/test_connection/"]
    }
  }
}

# Create a rule to forward to port 8002 target group
resource "aws_lb_listener_rule" "https_rule_8002" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 200

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.prod_app_tg_8002.arn
  }

  condition {
    path_pattern {
      values = ["/test_connection/"]
    }
  }
}

# # Create a target group for port 8002 Dev
# resource "aws_lb_target_group" "dev_app_tg_8002" {
#   name     = "app-tg-8002-dev"
#   port     = 8002
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main_vpc.id

#   health_check {
#     path                = "/test_connection/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 5
#     unhealthy_threshold = 2
#     matcher             = "200"
#   }
# }
# #
# Attach EC2 instance to the target group for port 8001
resource "aws_lb_target_group_attachment" "app_tg_attachment_8001" {
  target_group_arn = aws_lb_target_group.prod_app_tg_8001.arn
  target_id        = aws_instance.backend_prod.id
  port             = 8001
}

# Attach EC2 instance to the target group for port 8002
resource "aws_lb_target_group_attachment" "app_tg_attachment_8002" {
  target_group_arn = aws_lb_target_group.prod_app_tg_8002.arn
  target_id        = aws_instance.backend_prod.id
  port             = 8002
}
