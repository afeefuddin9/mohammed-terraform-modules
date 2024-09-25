## Roles for ECS fargate
# The roles for the task execution
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.env_prefix}-ecsTaskRole"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
 
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.env_prefix}-ecs-staging-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
# create ecs cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.env_prefix}-App"
  tags = merge(
    #service specific tags should be last tags
    var.default_tags
  )
}
# create ecs task definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                = "${var.env_prefix}-APP"
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

    # defined in role.tf
  task_role_arn = aws_iam_role.ecs_task_role.arn

  container_definitions = var.container_definitions
  tags = merge(
    var.default_tags,
    #service specific tags should be last tags
  )
}

# create ecs service
resource "aws_ecs_service" "ecs_service1" {
  name            = "${var.env_prefix}-ServiceA"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = "${aws_ecs_task_definition.ecs_task_definition.family}:${aws_ecs_task_definition.ecs_task_definition.revision}"
  desired_count   = var.num_of_tasks
  launch_type                        = "FARGATE"
  tags = merge(
    var.default_tags,
    #service specific tags should be last tags
    var.prod_tags
  )
 network_configuration {
    security_groups  = var.security_groups_ids
    subnets          = var.subnet_ids
    assign_public_ip = var.assign_public_ip
          }
  load_balancer {
    target_group_arn = var.target_group_arn1
    container_port   = var.container_port
    container_name   = var.env_prefix
  }
/* deployment_controller {
      type = "CODE_DEPLOY"
  }*/
    depends_on = [var.listener1]
}

# create ecs service
resource "aws_ecs_service" "ecs_service2" {
  count = var.create_bluegreen ? 1 : 0
  name            = "${var.env_prefix}-ServiceB"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = "${aws_ecs_task_definition.ecs_task_definition.family}:${aws_ecs_task_definition.ecs_task_definition.revision}"
  desired_count   = var.num_of_tasks
  launch_type                        = "FARGATE"
  tags = merge(
    var.default_tags,
    #service specific tags should be last tags
    var.prod_tags
  )
 network_configuration {
    security_groups  = var.security_groups_ids
    subnets          = var.subnet_ids
    assign_public_ip = var.assign_public_ip
    }
load_balancer {
    target_group_arn = var.target_group_arn2
    container_port   = var.container_port
    container_name   = var.env_prefix
  }
/*  deployment_controller {
      type = "CODE_DEPLOY"
  }*/
 depends_on = [var.listener2]
}

resource "aws_appautoscaling_target" "autoscale_target" {
service_namespace  = "ecs"
resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service1.name}"
scalable_dimension = "ecs:service:DesiredCount"
max_capacity       = var.service_count_max
min_capacity       = var.service_count_min
depends_on = [aws_ecs_service.ecs_service1]
}
resource "aws_appautoscaling_policy" "scale_up" {
name               = "${var.env_prefix}-scale-up"
service_namespace  = aws_appautoscaling_target.autoscale_target.service_namespace
resource_id        = aws_appautoscaling_target.autoscale_target.resource_id
scalable_dimension = aws_appautoscaling_target.autoscale_target.scalable_dimension
step_scaling_policy_configuration {
  adjustment_type         = "ChangeInCapacity"
  cooldown                = "300"
  metric_aggregation_type = "Average"
  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment          = 1
  }
}
depends_on = [aws_appautoscaling_target.autoscale_target]
}
resource "aws_appautoscaling_policy" "scale_down" {
name               = "${var.env_prefix}-scale-down"
service_namespace  = aws_appautoscaling_target.autoscale_target.service_namespace
resource_id        = aws_appautoscaling_target.autoscale_target.resource_id
scalable_dimension = aws_appautoscaling_target.autoscale_target.scalable_dimension
step_scaling_policy_configuration {
  adjustment_type         = "ChangeInCapacity"
  cooldown                = "300"
  metric_aggregation_type = "Average"
  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment          = -1
  }
}
depends_on = [aws_appautoscaling_target.autoscale_target]
}
resource "aws_cloudwatch_metric_alarm" "high" {
  alarm_name          = "${var.env_prefix}-alarm-high"
  alarm_description   = "Alarm monitors high utilization for scaling up"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = "75"
  alarm_actions       = [aws_appautoscaling_policy.scale_up.arn]
  metric_name         = "CPUUtilization"
  period              = "60"
  statistic           = "Average"
  namespace           = "AWS/ECS"
  dimensions = {
    ServiceName = aws_ecs_service.ecs_service1.name
  }
  tags = var.default_tags

  depends_on = [aws_appautoscaling_policy.scale_up]
}
resource "aws_cloudwatch_metric_alarm" "low" {
  alarm_name          = "${var.env_prefix}-alarm-low"
  alarm_description   = "Alarm monitors high utilization for scaling up"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = "25"
  alarm_actions       = [aws_appautoscaling_policy.scale_down.arn]
  metric_name         = "CPUUtilization"
  period              = "60"
  statistic           = "Average"
  namespace           = "AWS/ECS"
  dimensions = {
    ServiceName = aws_ecs_service.ecs_service1.name
  }
  tags = var.default_tags

  depends_on = [aws_appautoscaling_policy.scale_down]
}
### Service 2 step scaling####
resource "aws_appautoscaling_target" "autoscale_target2" {
count = var.enable_step_scaling_for_service2 ? 1:0
service_namespace  = "ecs"
resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service2[0].name}"
scalable_dimension = "ecs:service:DesiredCount"
max_capacity       = var.service_count_max
min_capacity       = var.service_count_min
depends_on = [aws_ecs_service.ecs_service2]
}
resource "aws_appautoscaling_policy" "scale_up2" {
count = var.enable_step_scaling_for_service2 ? 1:0
name               = "${var.env_prefix}-scale-up-service2"
service_namespace  = aws_appautoscaling_target.autoscale_target2[count.index].service_namespace
resource_id        = aws_appautoscaling_target.autoscale_target2[count.index].resource_id
scalable_dimension = aws_appautoscaling_target.autoscale_target2[count.index].scalable_dimension
step_scaling_policy_configuration {
  adjustment_type         = "ChangeInCapacity"
  cooldown                = "300"
  metric_aggregation_type = "Average"
  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment          = 1
  }
}
depends_on = [aws_appautoscaling_target.autoscale_target2]
}
resource "aws_appautoscaling_policy" "scale_down2" {
count = var.enable_step_scaling_for_service2 ? 1:0
name               = "${var.env_prefix}-scale-down-service2"
service_namespace  = aws_appautoscaling_target.autoscale_target2[count.index].service_namespace
resource_id        = aws_appautoscaling_target.autoscale_target2[count.index].resource_id
scalable_dimension = aws_appautoscaling_target.autoscale_target2[count.index].scalable_dimension
step_scaling_policy_configuration {
  adjustment_type         = "ChangeInCapacity"
  cooldown                = "300"
  metric_aggregation_type = "Average"
  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment          = -1
  }
}
depends_on = [aws_appautoscaling_target.autoscale_target2]
}
resource "aws_cloudwatch_metric_alarm" "high-service2" {
  count = var.enable_step_scaling_for_service2 ? 1:0
  alarm_name          = "${var.env_prefix}-alarm-high-service2"
  alarm_description   = "Alarm monitors high utilization for scaling up"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = "75"
  alarm_actions       = [aws_appautoscaling_policy.scale_up2[0].arn]
  metric_name         = "CPUUtilization"
  period              = "60"
  statistic           = "Average"
  namespace           = "AWS/ECS"
  dimensions = {
    ServiceName = aws_ecs_service.ecs_service2[0].name
  }
  tags = var.default_tags

  depends_on = [aws_appautoscaling_policy.scale_up2]
}
resource "aws_cloudwatch_metric_alarm" "low-serive2" {
  count = var.enable_step_scaling_for_service2 ? 1:0
  alarm_name          = "${var.env_prefix}-alarm-low-service2"
  alarm_description   = "Alarm monitors high utilization for scaling up"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = "25"
  alarm_actions       = [aws_appautoscaling_policy.scale_down2[0].arn]
  metric_name         = "CPUUtilization"
  period              = "60"
  statistic           = "Average"
  namespace           = "AWS/ECS"
  dimensions = {
    ServiceName = aws_ecs_service.ecs_service2[0].name
  }
  tags = var.default_tags

  depends_on = [aws_appautoscaling_policy.scale_up2]
}
