# create beanstalk application
resource "aws_elastic_beanstalk_application" "bg-app" {
  name        = "${var.env_prefix}-app"
  description = var.appdescription
}

# create beanstalk environment(blue/green)
resource "aws_elastic_beanstalk_environment" "bg-env1" {
  name                = "${var.env_prefix}-app-env1"
  application         = aws_elastic_beanstalk_application.bg-app.name
  solution_stack_name = var.stack_name
  cname_prefix        = "${var.env_prefix}-prod"
  description         = var.envdescription

  tags = merge(
    var.default_tags,

    #prod_tags should be last tag 
    var.prod_tags,
  )

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    #value     = local.vpc_id
    value = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    #value     = join(",", local.instance_subnets)
    value = join(",", var.instance_subnets)
  }
  
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "LoadBalancerType"
    value = "application"
  }
  
  setting {
    namespace = "aws:elbv2:listener:default"
    name = "ListenerEnabled"
    value = "false"
  }

setting {
    namespace = "aws:elbv2:listener:${var.ssl_port}"
    name = "Protocol"
    value = "HTTPS"
  }


setting {
    namespace = "aws:elbv2:listener:${var.ssl_port}"
    name = "SSLCertificateArns"
    value = var.cert_arn
  }

}

# create beanstalk environment(blue/green)
resource "aws_elastic_beanstalk_environment" "bg-env2" {
  name                = "${var.env_prefix}-app-env2"
  application         = aws_elastic_beanstalk_application.bg-app.name
  solution_stack_name = var.stack_name
  cname_prefix        = "${var.env_prefix}-stg"
  description         = var.envdescription

  tags = merge(
    var.default_tags,

    #stg_tags should be last tag    
    var.stg_tags,
  )

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    #value     = local.vpc_id
    value = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    #value     = join(",", local.instance_subnets)
    value = join(",", var.instance_subnets)
  }
  
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "LoadBalancerType"
    value = "application"
  }

  setting {
    namespace = "aws:elbv2:listener:default"
    name = "ListenerEnabled"
    value = "false"
  }

setting {
    namespace = "aws:elbv2:listener:${var.ssl_port}"
    name = "Protocol"
    value = "HTTPS"
  }


setting {
    namespace = "aws:elbv2:listener:${var.ssl_port}"
    name = "SSLCertificateArns"
    value = var.cert_arn
  }
  
}
