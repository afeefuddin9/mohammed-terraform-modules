resource "aws_lb_target_group" "tfer--PocDxinfraportal-TG" {
  deregistration_delay               = "300"
  lambda_multi_value_headers_enabled = "false"
  proxy_protocol_v2                  = "false"
  connection_termination             = "false"

  health_check {
    enabled             = "true"
    healthy_threshold   = "5"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
    unhealthy_threshold = "2"
  }

  load_balancing_algorithm_type = "round_robin"
  name                          = "PocDxinfraportal-TG"
  port                          = "80"
  protocol                      = "HTTP"
  protocol_version              = "HTTP1"
  slow_start                    = "0"

  stickiness {
    cookie_duration = "86400"
    enabled         = "false"
    type            = "lb_cookie"
  }

  tags = {
    Billing          = "dxplatform"
    Owner            = "DXInfra"
    Project          = "dxplatform"
    Usage            = "arn:aws:elasticloadbalancing:ap-southeast-1:768502287836:targetgroup/PocDxinfraportal-TG/8b2017faf2b0985d"
    Usage-tag-source = "dxpf-aws-resource-tagger"
    application      = "dxplatform-portal"
  }

  target_type = "instance"
  vpc_id      = "vpc-8481afe3"
}

resource "aws_lb_target_group" "tfer--PocDxinfraportalStaging-TG" {
  deregistration_delay               = "300"
  lambda_multi_value_headers_enabled = "false"
  proxy_protocol_v2                  = "false"
  connection_termination             = "false"

  health_check {
    enabled             = "true"
    healthy_threshold   = "5"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
    unhealthy_threshold = "2"
  }

  load_balancing_algorithm_type = "round_robin"
  name                          = "PocDxinfraportalStaging-TG"
  port                          = "80"
  protocol                      = "HTTP"
  protocol_version              = "HTTP1"
  slow_start                    = "0"

  stickiness {
    cookie_duration = "86400"
    enabled         = "false"
    type            = "lb_cookie"
  }

  tags = {
    Billing          = "dxplatform"
    Owner            = "DXInfra"
    Project          = "dxplatform"
    Usage            = "arn:aws:elasticloadbalancing:ap-southeast-1:768502287836:targetgroup/PocDxinfraportalStaging-TG/2d5b72c990c0ea18"
    Usage-tag-source = "dxpf-aws-resource-tagger"
    application      = "dxplatform-portal"
  }

  target_type = "instance"
  vpc_id      = "vpc-8481afe3"
}
