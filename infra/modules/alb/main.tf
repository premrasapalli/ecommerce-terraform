#########################################
# Application Load Balancer (ALB) Module
#########################################

terraform {
  required_version = ">= 1.0"
}

####################
# Security Group
####################

resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.enable_https ? [1] : []
    content {
      description = "Allow HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.project_name}-alb-sg"
  }, var.tags)
}

####################
# Application Load Balancer
####################

resource "aws_lb" "alb" {
  name               = "${var.project_name}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets

  tags = merge({
    Name = "${var.project_name}-alb"
  }, var.tags)
}

###########################
# Target Group for ECS
###########################

resource "aws_lb_target_group" "ecs_tg" {
  name        = "${var.project_name}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = merge({
    Name = "${var.project_name}-tg"
  }, var.tags)
}

###########################
# HTTP Listener (80 → 443 Redirect)
###########################

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = var.enable_https ? "redirect" : "forward"

    # redirect behavior IF https enabled
    dynamic "redirect" {
      for_each = var.enable_https ? [1] : []
      content {
        protocol   = "HTTPS"
        port       = "443"
        status_code = "HTTP_301"
      }
    }

    # forward behavior IF https disabled
    dynamic "forward" {
      for_each = var.enable_https ? [] : [1]
      content {
        target_group {
          target_group_arn = aws_lb_target_group.ecs_tg.arn
        }
      }
    }
  }
}

###########################
# HTTPS Listener
###########################

resource "aws_lb_listener" "https_listener" {
  count             = var.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "forward"

    forward {
      target_group {
        target_group_arn = aws_lb_target_group.ecs_tg.arn
      }
    }
  }
}

###########################
# Host-Based Routing Rule
###########################

resource "aws_lb_listener_rule" "domain_based" {
  count = var.enable_https && var.domain_name != "" ? 1 : 0

  listener_arn = aws_lb_listener.https_listener[0].arn
  priority     = 100

  condition {
    host_header {
      values = [var.domain_name]
    }
  }

  action {
    type = "forward"
    forward {
      target_group {
        target_group_arn = aws_lb_target_group.ecs_tg.arn
      }
    }
  }
}

###########################
# Outputs
###########################

output "alb_arn" {
  value = aws_lb.alb.arn
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.ecs_tg.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

