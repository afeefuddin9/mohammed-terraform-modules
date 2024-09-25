resource "aws_lb" "tfer--PocDxinfraportal" {
  access_logs {
    bucket  = "dxpf-alb-logs-singapore"
    enabled = "true"
    prefix  = "dxpf/PocDxinfraportal"
  }

  drop_invalid_header_fields       = "false"
  enable_cross_zone_load_balancing = "true"
  enable_deletion_protection       = "true"
  #lambda_multi_value_headers_enabled = "false"
  #proxy_protocol_v2                  = "false"
  enable_http2       = "true"
  idle_timeout       = "60"
  internal           = "false"
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  name               = "PocDxinfraportal"
  security_groups    = ["sg-066cff47579adc6ec", "sg-0ad279f7c608e0792", "sg-0b8596d57d5da1109", "sg-0d0b7e4029a649675", "sg-0f6fe1f0cf3e67d6c"]

  subnet_mapping {
    subnet_id = "subnet-0cad67794b02582b4"
  }

  subnet_mapping {
    subnet_id = "subnet-3ca76e65"
  }

  subnet_mapping {
    subnet_id = "subnet-5c31233b"
  }

  subnets = ["subnet-0cad67794b02582b4", "subnet-3ca76e65", "subnet-5c31233b"]

  tags = {
    Billing     = "dxplatform"
    Owner       = "DXInfra"
    Project     = "dxplatform"
    Usage       = "arn:aws:elasticloadbalancing:ap-southeast-1:768502287836:loadbalancer/app/PocDxinfraportal/33679289b6794a08"
    application = "dxplatform-portal"
  }
}
