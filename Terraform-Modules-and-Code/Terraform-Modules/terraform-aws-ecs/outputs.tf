output "BService" {
  value       = aws_ecs_service.ecs_service1.name
  description = "ECS service name"
}
output "GService" {
  #value = aws_ecs_service.ecs_service2.name 
  value = try(aws_ecs_service.ecs_service2[0].name, null)
  description = "ECS service name"
}
output "ClusterName" {
  value       = aws_ecs_cluster.ecs_cluster.name
  description = "ECS cluster name"
}
output "TaskName" {
  value       = aws_ecs_task_definition.ecs_task_definition.family
  description = "Task definition name"
}
output "TaskName_service2" {
  value       = try(aws_ecs_task_definition.ecs_task_definition-service2[0].family, null)
  description = "Task definition name"
}
