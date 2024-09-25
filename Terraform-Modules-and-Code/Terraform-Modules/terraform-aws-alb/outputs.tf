output "alb_id" {
  description = "The ID of the Application load balancer created"
  value       = aws_lb.ApplicationLoadBalancer.id
}

output "alb_arn" {
  description = "The ARN of the Application load balancer created."
  value       = aws_lb.ApplicationLoadBalancer.arn
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.ApplicationLoadBalancer.dns_name
}

output "target_group_arns1" {
  description = "ARNs of the target groups."
  value       = aws_lb_target_group.alb_target_group.arn
}
output "target_group_listener_arn" {
  description = "ARNs of the target groups."
  value       = aws_lb_listener.alb_https_listner.*.arn
}
output "target_group_arns2" {
  description = "ARNs of the target groups."
  value = concat(aws_lb_target_group.alb_target_group2.*.arn, [""])[0]
}
/*output "target_group_listener_arn2" {
  description = "ARNs of the target groups."
  value = concat(aws_lb_listener.alb_https_listner2.*.arn, [""])[0] 
}*/
