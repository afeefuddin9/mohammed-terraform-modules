# create ecs cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.env_prefix}-App"
}
# create ecs task definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                = "${var.env_prefix}-APP"
  container_definitions = var.container_definitions
  tags = merge(
    var.default_tags,
    #service specific tags should be last tags
  )
/*   volume {
    name = var.volume_name
    host_path = "/mnt/efs"
  }
  */
   dynamic "volume" {
    for_each = var.volume
    content {
      name = var.volume_name
      host_path = var.efs_host_path
    }
   }
}
# create ecs task definition
resource "aws_ecs_task_definition" "ecs_task_definition-service2" {
  count           = var.enable_ecs_task_definition2 ? 1 : 0
  family                = "${var.env_prefix_service2}-APP"
  container_definitions = var.container_definitions_service2
  task_role_arn = var.task_role_arn
  tags = merge(
    var.default_tags,
    #service specific tags should be last tags
  )
}
# create ecs service
resource "aws_ecs_service" "ecs_service1" {
  name            = "${var.env_prefix}-ServiceA"
  iam_role        = var.iam_role
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = "${aws_ecs_task_definition.ecs_task_definition.family}:${aws_ecs_task_definition.ecs_task_definition.revision}"
  desired_count   = var.num_of_tasks
  launch_type     = "EC2"
  tags = merge(
    #service specific tags should be last tags
    var.prod_tags
  )

  load_balancer {
    target_group_arn = var.alb_target_group1
    container_port   = var.container_port
    container_name   = var.env_prefix
  }
  #aws_lb_target_group.alb_target_group1.arn
  depends_on = [var.listener1]
  lifecycle {
  ignore_changes = ["task_definition"]
  }

}

# create ecs service
resource "aws_ecs_service" "ecs_service2" {
  count           = var.enable_ecs_service2 ? 1 : 0
  name            = "${var.env_prefix_service2}-ServiceB"
  iam_role        = var.iam_role_service2
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = var.enable_ecs_task_definition2 ? "${aws_ecs_task_definition.ecs_task_definition-service2[count.index].family}:${aws_ecs_task_definition.ecs_task_definition-service2[count.index].revision}" : "${aws_ecs_task_definition.ecs_task_definition.family}:${aws_ecs_task_definition.ecs_task_definition.revision}"
  desired_count   = var.num_of_tasks
  launch_type     = "EC2"
  tags = merge(
    #service specific tags should be last tags
    var.stg_tags
  )
  load_balancer {
    target_group_arn = var.alb_target_group2
    container_port   = var.container_port_service2
    container_name   = var.env_prefix_service2
  }
  depends_on = [var.listener2]
 lifecycle {
  ignore_changes = [task_definition]
  }
}