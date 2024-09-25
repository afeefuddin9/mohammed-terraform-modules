output "codepipeline_arn" {
  value       = aws_iam_role.codepipeline_role.arn
  description = "codepipeline role"
}
output "codedeploy_arn" {
  value       = aws_iam_role.codedeploy_role.arn
  description = "codedeploy role"
}
/*output "codebuild_arn" {
  value       = aws_iam_role.codebuild_role.arn
  description = "codedeploy role"
}
*/