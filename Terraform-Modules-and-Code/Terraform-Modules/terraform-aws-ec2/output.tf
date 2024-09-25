output "ec2_instance" {
  value = aws_instance.ec2_resource.id
}
output "ami_id" {
  value = var.ami_id
}
