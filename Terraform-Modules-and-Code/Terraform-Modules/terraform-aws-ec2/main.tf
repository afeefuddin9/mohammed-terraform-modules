#Create ec2 IAM Role
resource "aws_iam_role" "role" {
  count              = var.create_role_ec2 ? 1 : 0
  name               = "${var.instance_profile_prefix}-SSM-role"
  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": "VisualEditor1"
        }
      ]
    }
EOF
}
resource "aws_iam_role_policy_attachment" "policy1" {
  count      = var.create_role_ec2 ? 1 : 0
  role       = aws_iam_role.role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
# Creating the iam instance profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  count = var.create_role_ec2 ? 1 : 0
  name  = "${var.instance_profile_prefix}-instance_profile_name"
  role  = aws_iam_role.role[count.index].name
}

data "aws_ssm_parameter" "cw_agent" {
  name        = var.userdata_parameter_name
}
# create a new ec2 instance
resource "aws_instance" "ec2_resource" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.ec2_key_pair_name

  iam_instance_profile = var.create_role_ec2 ? aws_iam_instance_profile.ec2_instance_profile[0].id : var.instance_profile_name

  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.EC2_security_grp

  user_data = var.enable_userdata ? data.aws_ssm_parameter.cw_agent.name : null

  monitoring                  = var.monitor
  associate_public_ip_address = var.associate_public_ip_address
  tags = merge(
    var.default_tags, var.Infra_tags, var.Schedule_tags
  )
  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true
  }
  lifecycle {
    create_before_destroy = true
  }

  dynamic "ebs_block_device" {
    for_each = [
      for i in var.ebs_block_device :
      {
        enabled               = i.enabled
        delete_on_termination = i.delete_on_termination
        encrypted             = i.encrypted
        device_name           = i.device_name
        volume_size           = i.volume_size
        volume_type           = i.volume_type
      } if i.enabled == true
    ]

    content {
      delete_on_termination = ebs_block_device.value.delete_on_termination
      device_name           = ebs_block_device.value.device_name
      encrypted             = ebs_block_device.value.encrypted
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = ebs_block_device.value.volume_type
    }
  }
}
resource "aws_cloudwatch_metric_alarm" "auto_recovery_alarm" {
  count               = var.create_recovery_alarm ? 1 : 0
  alarm_name          = "EC2AutoRecover-${aws_instance.ec2_resource.id}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.interval
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = var.status_check_period
  statistic           = "Minimum"
  dimensions = {
    InstanceId = aws_instance.ec2_resource.id
  }
  alarm_actions     = ["arn:aws:automate:${var.region}:ec2:recover", var.alarm_sns_topic_arn]
  threshold         = var.status_check_threshold
  alarm_description = "Auto recover the EC2 instance if Status Check fails."
}
