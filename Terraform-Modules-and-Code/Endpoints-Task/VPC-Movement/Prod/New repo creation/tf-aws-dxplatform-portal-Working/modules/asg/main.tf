###################################################################################
################## Create the Launch Configuration#################################
###################################################################################
resource "aws_iam_role" "role" {
  name = "${var.asg_instance_profile_prefix}-SSM-role"
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
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.asg_instance_profile_prefix}-instance-profile"
  path = "/"
  role       = aws_iam_role.role.name
}

# Create Launch Template for Auto Scale Groups
resource "aws_launch_template" "launch_template" {
  name_prefix = "${var.env_prefix}-"

  block_device_mappings {
    device_name = var.device_name
    ebs {
      volume_size = var.EBS_volume_size
      encrypted   = var.ebs_encrypted
      delete_on_termination = true
      volume_type           = "gp2"
     }
  }

  update_default_version = var.default_version_update

  ebs_optimized = var.ebs_optimized

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }
 
  image_id = var.image_id

  instance_type = var.instance_type

  key_name                    = var.key_pair_name

  monitoring {
    enabled = var.enable_monitoring
  }

  network_interfaces {
    associate_public_ip_address = var.public_ip_address
    security_groups             = var.sec_grp
    delete_on_termination       = true
  }

  /*  placement {
      availability_zone = ""
    }*/

  # use only if network interfaces resource block not in use.
  #vpc_security_group_ids = [var.sec_grp]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = var.NameTag
      Billing = var.BillingTag
      Owner   = var.OwnerTag
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name    = var.Volume_NameTag
      Billing = var.BillingTag
      Owner   = var.OwnerTag
    }
  }
  user_data                 = var.userDataDetails
}

# create autoscaling group
resource "aws_autoscaling_group" "autoscaling-group" {
  name                = "${var.env_prefix}-Asg"
  max_size            = var.max_instance_size
  min_size            = var.min_instance_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = [var.ec2_subnet_a, var.ec2_subnet_b]
  #launch_configuration = aws_launch_configuration.launch_configuration.name
  #default_cooldown     = var.default_cooldown
  enabled_metrics      = var.enabled_metrics
  termination_policies = var.termination_policies
  metrics_granularity       = var.metrics_granularity
  health_check_type    = var.health_check_type
  health_check_grace_period  = var.health_check_grace_period
  target_group_arns = var.target_grp_arn
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  # tags = concat(
  #   [
  #     {
  #       "key"                 = "Name"
  #       "value"               = var.NameTag
  #       "propagate_at_launch" = true
  #     },
  #   ],
  #   [
  #     {
  #       "key"                 = "Billing"
  #       "value"               = var.BillingTag
  #       "propagate_at_launch" = true
  #     },
  #   ],
  #   [
  #     {
  #       "key"                 = "Owner"
  #       "value"               = var.OwnerTag
  #       "propagate_at_launch" = true
  #     },
  #   ]
  # )

  #adding new tage
  tag {
    key                 = "Name"
    value               = var.NameTag
    propagate_at_launch = true
  }

  tag {
    key                 = "Billing"
    value               = var.BillingTag
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = var.OwnerTag
    propagate_at_launch = true
  }
  
}

# Create AutoScale Notification using SNS.
resource "aws_autoscaling_notification" "asg_notification" {
  count       = var.enable_asg_notification ? 1 : 0
  group_names = [aws_autoscaling_group.autoscaling-group.name]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = var.sns_topic_arn
}
