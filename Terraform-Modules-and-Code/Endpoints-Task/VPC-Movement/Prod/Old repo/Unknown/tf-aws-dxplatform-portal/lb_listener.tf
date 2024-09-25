
resource "aws_lb_listener" "tfer--arn-003A-aws-003A-elasticloadbalancing-003A-ap-southeast-1-003A-768502287836-003A-listener-002F-app-002F-PocDxinfraportal-002F-33679289b6794a08-002F-02c05812d7d48138" {
  certificate_arn = "arn:aws:acm:ap-southeast-1:768502287836:certificate/4a8f0357-b09d-4204-9084-f7282f39678d"

  default_action {
    authenticate_cognito {
      on_unauthenticated_request = "authenticate"
      scope                      = "openid"
      session_cookie_name        = "AWSELBAuthSessionCookie"
      session_timeout            = "604800"
      user_pool_arn              = "arn:aws:cognito-idp:ap-southeast-1:768502287836:userpool/ap-southeast-1_HxhkZHuGI"
      user_pool_client_id        = "7e48u7omo3g02ejefvj63lr122"
      user_pool_domain           = "dx-infra"
    }

    order = "1"
    type  = "authenticate-cognito"
  }

  default_action {
    order            = "2"
   #target_group_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:768502287836:targetgroup/PocDxinfraportalStaging-TG/2d5b72c990c0ea18" #OLD ARN
    target_group_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:768502287836:targetgroup/PocDxinfraportalStaging-TG/0e4c8974ea410bbe" #NEW ARN
    type             = "forward"
  }

  load_balancer_arn = data.terraform_remote_state.alb.outputs.aws_lb_tfer--PocDxinfraportal_id
  port              = "8080"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  tags = {

    application = "dxplatform-portal"

  }
}


resource "aws_lb_listener" "tfer--arn-003A-aws-003A-elasticloadbalancing-003A-ap-southeast-1-003A-768502287836-003A-listener-002F-app-002F-PocDxinfraportal-002F-33679289b6794a08-002F-5ed849ab022bb889" {
  certificate_arn = "arn:aws:acm:ap-southeast-1:768502287836:certificate/4a8f0357-b09d-4204-9084-f7282f39678d"

  default_action {
    authenticate_cognito {
      on_unauthenticated_request = "authenticate"
      scope                      = "openid"
      session_cookie_name        = "AWSELBAuthSessionCookie"
      session_timeout            = "604800"
      user_pool_arn              = "arn:aws:cognito-idp:ap-southeast-1:768502287836:userpool/ap-southeast-1_HxhkZHuGI"
      user_pool_client_id        = "4ju5plag5o7gfkt0pv9j57dmvl"
      user_pool_domain           = "dx-infra"
    }

    order = "1"
    type  = "authenticate-cognito"
  }

  default_action {
    order            = "2"
    #target_group_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:768502287836:targetgroup/PocDxinfraportal-TG/8b2017faf2b0985d" #Old ARN
    target_group_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:768502287836:targetgroup/PocDxinfraportal-TG/325740426d5e9493" #NEW ARN
    type             = "forward"
  }

  load_balancer_arn = data.terraform_remote_state.alb.outputs.aws_lb_tfer--PocDxinfraportal_id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  tags = {

    application = "dxplatform-portal"

  }
}

resource "aws_lb_listener" "tfer--arn-003A-aws-003A-elasticloadbalancing-003A-ap-southeast-1-003A-768502287836-003A-listener-002F-app-002F-PocDxinfraportal-002F-33679289b6794a08-002F-d719904942485057" {

  default_action {
    order = "1"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }

    type = "redirect"
  }

  load_balancer_arn = data.terraform_remote_state.alb.outputs.aws_lb_tfer--PocDxinfraportal_id
  port              = "80"
  protocol          = "HTTP"
  tags = {

    application = "dxplatform-portal"

  }
}