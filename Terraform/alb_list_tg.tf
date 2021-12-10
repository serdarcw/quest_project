resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sec_group.id]
  subnets            = ["subnet-a57c8ffa","subnet-f67c79c8","subnet-c5830288", "subnet-9b8c70ba", "subnet-b0f701d6", "subnet-0404ac0a"]
  ip_address_type    = "ipv4"
  enable_deletion_protection = false
  tags = local.tags
}
resource "aws_lb_target_group" "WebServerTargetGroup" {
  name     = "WebServerTargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id
}

# Newly created ec2 instance is added to taret group with this attachment block.
resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.WebServerTargetGroup.arn
  target_id        = aws_instance.web.id
  port             = 80
}


# listener has to rules which are 80 and 443. first rule is redirect traffic from 80 to 443. second rule is forward traffic to the target group.
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
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

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
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
resource "aws_lb_listener" "front_end1" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = local.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.WebServerTargetGroup.arn
  }
}