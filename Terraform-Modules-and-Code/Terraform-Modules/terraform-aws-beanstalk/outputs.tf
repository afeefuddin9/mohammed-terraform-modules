output "beanstalk_application_name" {
  value = aws_elastic_beanstalk_application.bg-app.name
  description = "beanstalk application name"
}

output "beanstalk_environment_1" {
  value = aws_elastic_beanstalk_environment.bg-env1.name
  description = "beanstalk env1 name"
}

output "beanstalk_environment_2" {
  value = aws_elastic_beanstalk_environment.bg-env2.name
  description = "beanstalk env2 name"
}
