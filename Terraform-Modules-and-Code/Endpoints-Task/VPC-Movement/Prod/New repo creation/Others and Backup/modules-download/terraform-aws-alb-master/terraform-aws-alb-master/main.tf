# Creating the alb
resource "aws_lb" "ApplicationLoadBalancer" {
  name            = "${var.envPrefix}-Alb"
  internal        = var.internal
  security_groups = var.alb_security_grp

  subnets = [
    var.alb_subnet1,
    var.alb_subnet2
  ]

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  tags = merge(
    var.default_tags
  )
  enable_deletion_protection = false
  access_logs {
    enabled = var.production_evn ? true : false
    bucket  = var.s3_bucket
    prefix  = var.s3_bucket_prefix
  }
}
# Create target group to be used in alb
resource "aws_lb_target_group" "alb_target_group" {
  name        = "${var.envPrefix}-TG01"
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id
  tags = merge(
    var.default_tags,
    #service specific tags should be last tags
  )
  stickiness {
    type            = "lb_cookie"
    cookie_duration = var.cookie_duration
    enabled         = var.enable_stickiness
  }
  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.healthcheck_timeout
    interval            = var.healthcheck_interval
    matcher             = var.http_health_check_matcher
    path                = var.health_check_path
  }
}
#Create the Default lister for http redirection
resource "aws_lb_listener" "http_redirection" {
  load_balancer_arn = aws_lb.ApplicationLoadBalancer.arn
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
# create alb listener and associate a target group
resource "aws_lb_listener" "alb_https_listner" {
  count             = var.create_listener_without_auth ? 1 : 0
  load_balancer_arn = aws_lb.ApplicationLoadBalancer.arn
  port              = var.prod_lstn_port
  protocol          = "HTTPS"
  ssl_policy        = var.alb_ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
# create alb listener and associate a target group
resource "aws_lb_listener" "alb_https_listner_auth" {
  count             = var.create_listener_with_auth ? 1 : 0
  load_balancer_arn = aws_lb.ApplicationLoadBalancer.arn
  port              = var.prod_lstn_port
  protocol          = "HTTPS"
  ssl_policy        = var.alb_ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type = "authenticate-oidc"
    authenticate_oidc {
      authorization_endpoint = var.authorization_endpoint
      client_id              = var.client_id
      client_secret          = var.client_secret
      issuer                 = var.issuer
      token_endpoint         = var.token_endpoint
      user_info_endpoint     = var.user_info_endpoint
    }
  }
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
# Create target group to be used in alb
resource "aws_lb_target_group" "alb_target_group2" {
  count       = var.enable_second_target_group ? 1 : 0
  name        = "${var.envPrefix}-TG02"
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id
  tags = merge(
    var.default_tags,
    #service specific tags should be last tags
  )
  stickiness {
    type            = "lb_cookie"
    cookie_duration = var.cookie_duration
    enabled         = var.enable_stickiness
  }
  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.healthcheck_timeout
    interval            = var.healthcheck_interval
    matcher             = var.http_health_check_matcher
  }
}
#Create the Default lister for http redirection
resource "aws_lb_listener" "http_redirection2" {
  count             = var.enable_second_target_group ? 1 : 0
  load_balancer_arn = aws_lb.ApplicationLoadBalancer.arn
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
# create alb listener and associate a target group
resource "aws_lb_listener" "alb_https_listner2" {
  count             = var.create_listener_rule_without_auth_for_TG2 ? 1 : 0
  load_balancer_arn = aws_lb.ApplicationLoadBalancer.arn
  port              = var.prod_lstn_port
  protocol          = "HTTPS"
  ssl_policy        = var.alb_ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group2[count.index].arn
  }
}
# create alb listener and associate a target group
resource "aws_lb_listener" "alb_https_listner_auth2" {
  count             = var.create_listener_with_auth_for_TG2 ? 1 : 0
  load_balancer_arn = aws_lb.ApplicationLoadBalancer.arn
  port              = var.prod_lstn_port
  protocol          = "HTTPS"
  ssl_policy        = var.alb_ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type = "authenticate-oidc"
    authenticate_oidc {
      authorization_endpoint = var.authorization_endpoint
      client_id              = var.client_id
      client_secret          = var.client_secret
      issuer                 = var.issuer
      token_endpoint         = var.token_endpoint
      user_info_endpoint     = var.user_info_endpoint
    }
  }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group2[count.index].arn
  }
}
# Path based routing rule
resource "aws_lb_listener_rule" "listener_rule1" {
  count        = var.create_listener_rule_without_auth ? 1 : 0
  depends_on   = [aws_lb_target_group.alb_target_group]
  listener_arn = aws_lb_listener.alb_https_listner[count.index].arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.id
  }
  condition {
    path_pattern {
      values = [var.path_values]
    }
  }
}
# Register EC2 instances to Target Group.
resource "aws_lb_target_group_attachment" "tg-attachment" {
  count            = var.register_ec2_TG ? 1 : 0
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = var.ec2_instance_id
  port             = var.ec2_instance_port
}
