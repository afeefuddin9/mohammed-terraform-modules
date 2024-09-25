output "launch_template" {
  value = aws_launch_template.launch_template.id
}
output "ASG" {
  value = aws_autoscaling_group.autoscaling-group.id
}
output "IAM_role" {
  value = aws_iam_role.role.name
}
