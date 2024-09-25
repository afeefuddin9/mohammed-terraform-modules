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
  #security_groups    = ["sg-066cff47579adc6ec", "sg-0ad279f7c608e0792", "sg-0b8596d57d5da1109", "sg-0d0b7e4029a649675", "sg-0f6fe1f0cf3e67d6c"] #Old default SG id
  security_groups    = ["sg-05b4b3a1ad6ebbec5", "sg-0432c19e32b3c2134", "sg-0b11f958db2b7552f", "sg-089045f814116316a", "sg-0301de6b350f81ec3"]



  # subnet_mapping {
  #   #subnet_id = "subnet-0cad67794b02582b4" #Old default subnet id
  #   subnet_id = "subnet-0706a4093987cffe2"
  # }

  # subnet_mapping {
  #   subnet_id = "subnet-0d1625da824af2095"
  # }

  # subnet_mapping {
  #   subnet_id = "subnet-0be1ff242fdc5d191"
  # }

  #subnets = ["subnet-0cad67794b02582b4", "subnet-3ca76e65", "subnet-5c31233b"]
  subnets = ["subnet-0706a4093987cffe2", "subnet-0d1625da824af2095", "subnet-0be1ff242fdc5d191"]

  tags = {
    Billing     = "dxplatform"
    Owner       = "DXInfra"
    Project     = "dxplatform"
    Usage       = "arn:aws:elasticloadbalancing:ap-southeast-1:768502287836:loadbalancer/app/PocDxinfraportal/33679289b6794a08"
    application = "dxplatform-portal"
  }
}
