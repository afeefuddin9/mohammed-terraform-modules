#########################################
#             Alarms for EC2         #
#########################################
resource "aws_cloudwatch_metric_alarm" "auto_recovery_alarm" {
  count               = var.create_ec2_metrics ? 1 : 0
  alarm_name          = "${var.envPrefix}-EC2AutoRecover-${var.ec2_instance_id}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Minimum"
  dimensions = {
    InstanceId = var.ec2_instance_id
  }
  alarm_actions     = ["arn:aws:automate:${var.region}:ec2:recover", var.sns_topic_arn]
  threshold         = "5"
  alarm_description = "Auto recover the EC2 instance if Status Check fails."
  tags = merge(
    var.default_tags,
    #service specific tags should be last tags
  )
}
resource "aws_cloudwatch_metric_alarm" "cpu-high-utilization-ec2" {
  count               = var.create_ec2_metrics ? 1 : 0
  alarm_name          = "${var.envPrefix}-CPUUtilizationAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "85"
  dimensions = {
    InstanceId = var.ec2_instance_id
  }
  alarm_description = "This metric monitors the cpu utilization of ec2 instances"
  actions_enabled   = "true"
  alarm_actions     = [var.sns_topic_arn]
  tags = merge(
    var.default_tags,
    #service specific tags should be last tags
  )
}
resource "aws_cloudwatch_metric_alarm" "Memory_used_percent" {
  count               = var.create_ec2_metrics ? 1 : 0
  alarm_name          = "${var.envPrefix}-Memory-used-percent"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = "85"
  dimensions = {
    InstanceId = var.ec2_instance_id,
    ImageId = var.ami_id,
    InstanceType = var.instance_type
  }
  alarm_description = "This metric monitors the memory utilization of autoscaling instances"
  actions_enabled   = "true"
  alarm_actions     = [var.sns_topic_arn]
  tags = merge(
    var.default_tags,
    #service specific tags should be last tags
  )
}

resource "aws_cloudwatch_metric_alarm" "disk_used_percent" {
  count               = var.create_ec2_metrics ? 1 : 0
  alarm_name          = "${var.envPrefix}-disk-used-percent"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = "85"
  dimensions = {
    path=var.path
    InstanceId=var.ec2_instance_id
    ImageId=var.ami_id
    InstanceType=var.instance_type
    device=var.device
    fstype=var.fstype
  }
  alarm_description = "This metric monitors the disk utilization of ec2 instance"
  actions_enabled   = "true"
  alarm_actions     = var.sns_topic_arn2
  tags = merge(
    var.default_tags,
    #service specific tags should be last tags
  )
}
resource "aws_cloudwatch_metric_alarm" "EBS-Byte-Balance-ec2" {
  count               = var.EBS-Byte-Balance-ec2 ? 1 : 0
  alarm_name          = "${var.envPrefix}-EBS-Byte-Balance"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EBSByteBalance%"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "25"
  dimensions = {
    InstanceId = var.ec2_instance_id
  }
  alarm_description = "This metric is to know the byte balance of the ec2 instance"
  actions_enabled   = "true"
  alarm_actions     = [var.sns_topic_arn]
  tags = merge(
    var.default_tags,
    #service specific tags should be last tags
  )
}
#########################################
#             Alarms for ALB            #
#########################################
resource "aws_cloudwatch_metric_alarm" "target-healthy-count" {
  count               = var.create_alb_metrics ? 1 : 0
  alarm_name          = "${var.envPrefix}-Target-Healthy-Count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  dimensions = {
    LoadBalancer = var.alb_arn
    TargetGroup  = var.target_group_arns
  }
  alarm_description = "Trigger an alert when target group has 1 or more unhealthy hosts"
  alarm_actions     = [var.sns_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "target-response-time" {
  count               = var.create_alb_metrics ? 1 : 0
  alarm_name          = "${var.envPrefix}-Target-Response-Time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "5"
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    LoadBalancer = var.alb_arn
    TargetGroup  = var.target_group_arns
  }

  alarm_description = "Trigger an alert when response time in target group goes high"
  alarm_actions     = [var.sns_topic_arn]
}
resource "aws_cloudwatch_metric_alarm" "target-400-error" {
  count               = var.create_alb_metrics ? 1 : 0
  alarm_name          = "${var.envPrefix}-Target-400-error"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"

  dimensions = {
    LoadBalancer = var.alb_arn
    TargetGroup  = var.target_group_arns
  }

  alarm_description = "Trigger an alert when 4XX's in target group goes high"
  alarm_actions     = [var.sns_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "target-500-error" {
  count               = var.create_alb_metrics ? 1 : 0
  alarm_name          = "${var.envPrefix}-Target-500-error"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"

  dimensions = {
    LoadBalancer = var.alb_arn
    TargetGroup  = var.target_group_arns
  }

  alarm_description = "Trigger an alert when 5XX's in target group goes high"
  alarm_actions     = [var.sns_topic_arn]
}
#########################################
#             Alarms for ASG            #
#########################################

resource "aws_cloudwatch_metric_alarm" "cpu-high-utilization-asg" {
  count               = var.create_asg_metrics ? 1 : 0
  alarm_name          = "${var.envPrefix}-CPUUtilizationAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "85"
  dimensions = {
    AutoScalingGroupName = var.asg_id
  }
  alarm_description = "This metric monitors the cpu utilization of autoscaling instances"
  actions_enabled   = "true"
  alarm_actions     = [var.sns_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "auto_recovery_alarm-asg" {
  count               = var.create_asg_metrics ? 1 : 0
  alarm_name          = "${var.envPrefix}-EC2AutoRecover-${var.ec2_instance_id}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Minimum"
  dimensions = {
    #AutoScalingGroupName = var.asg_id
    InstanceId = var.ec2_instance_id
  }
  alarm_actions     = ["arn:aws:automate:${var.region}:ec2:recover", var.sns_topic_arn]
  threshold         = "5"
  alarm_description = "Auto recover the EC2 instance if Status Check fails."
}

resource "aws_cloudwatch_metric_alarm" "Memory_used_percent-asg" {
  count               = var.create_asg_metrics ? 1 : 0
  alarm_name          = "${var.envPrefix}-Memory-used-percent"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = "85"
  dimensions = {
    InstanceId = var.ec2_instance_id,
    ImageId = var.ami_id,
    InstanceType = var.instance_type,
    AutoScalingGroupName = var.asg_id
  }
  alarm_description = "This metric monitors the memory utilization of autoscaling instances"
  actions_enabled   = "true"
  alarm_actions     = [var.sns_topic_arn]
}
resource "aws_cloudwatch_metric_alarm" "disk_used_percent-asg" {
  count               = var.create_asg_metrics ? 1 : 0
  alarm_name          = "${var.envPrefix}-disk-used-percent"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = "85"
  dimensions = {
    AutoScalingGroupName = var.asg_id,
    path=var.path,
    InstanceId=var.ec2_instance_id,
    ImageId=var.ami_id,
    InstanceType=var.instance_type,
    device=var.device,
    fstype=var.fstype
  }
  alarm_description = "This metric monitors the disk utilization of autoscaling instances"
  actions_enabled   = "true"
  alarm_actions     = [var.sns_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "EBS-Byte-Balance-asg" {
  count               = var.EBS-Byte-Balance-asg ? 1 : 0
  alarm_name          = "${var.envPrefix}-EBS-Byte-Balance"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EBSByteBalance%"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "25"
  dimensions = {
    AutoScalingGroupName = var.asg_id
    #InstanceId = var.ec2_instance_id
  }
  alarm_description = "This metric is to know the byte balance of the autoscaling instances"
  actions_enabled   = "true"
  alarm_actions     = [var.sns_topic_arn]
}
#########################################
#             Alarms for Lambda         #
#########################################
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  count               = var.create_lambda_metrics ? 1 : 0
  alarm_name          = "${var.envPrefix}-lambda_errors"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "0"
  dimensions = {
    FunctionName = var.function_name
  }
  alarm_description = "This metric is to know the lambda errors"
  actions_enabled   = "true"
  alarm_actions     = [var.sns_topic_arn]
}
resource "aws_cloudwatch_metric_alarm" "lambda_Duration" {
  count               = var.create_lambda_metrics ? 1 : 0
  alarm_name          = "${var.envPrefix}-lambda_Duration"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "10"
  dimensions = {
    FunctionName = var.function_name
  }
  alarm_description = "This metric is to know the the lambda duration"
  actions_enabled   = "true"
  alarm_actions     = [var.sns_topic_arn]
}

