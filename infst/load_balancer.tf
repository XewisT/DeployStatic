# Create an Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "https_rds" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 8080
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.app_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rds.arn
  }
}

resource "aws_lb_listener" "https_redis" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 8081
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.app_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.redis.arn
  }
}

# Create a target group for Prod (RDS)
resource "aws_lb_target_group" "rds" {
  name     = "rds-tg"
  port     = 3000
  protocol = "HTTPS"
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

# Create a target group for Prod (Redis)
resource "aws_lb_target_group" "redis" {
  name     = "redis-tg"
  port     = 3001
  protocol = "HTTPS"
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

# Attach EC2 instances to Target Groups
resource "aws_lb_target_group_attachment" "rds_attachment" {
  target_group_arn = aws_lb_target_group.rds.arn
  target_id        = aws_instance.backend_prod.id
  port             = 3000
}

resource "aws_lb_target_group_attachment" "redis_attachment" {
  target_group_arn = aws_lb_target_group.redis.arn
  target_id        = aws_instance.backend_prod.id
  port             = 3001
}

# Define Listener Rules
resource "aws_lb_listener_rule" "rds_rule" {
  listener_arn = aws_lb_listener.https_rds.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rds.arn
  }

  condition {
    path_pattern {
      values = ["/test_connection/"]
    }
  }
}

resource "aws_lb_listener_rule" "redis_rule" {
  listener_arn = aws_lb_listener.https_redis.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.redis.arn
  }

  condition {
    path_pattern {
      values = ["/test_connection/"]
    }
  }
}
