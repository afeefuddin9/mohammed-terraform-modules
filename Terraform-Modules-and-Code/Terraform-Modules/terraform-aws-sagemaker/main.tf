resource "aws_sagemaker_notebook_instance" "Notebook_instance" {
  name          = "${var.envPrefix}-notebook-instance"
  role_arn      = var.role_arn
  instance_type = var.instance_type
  default_code_repository = aws_sagemaker_code_repository.code_repository.code_repository_name
  volume_size = var.volume_size
  subnet_id =var.subnet_id
  security_groups = var.security_groups
  lifecycle_config_name = aws_sagemaker_notebook_instance_lifecycle_configuration.lc.name
  tags = merge(
    {
      "Name" = format("%s-VPC", var.envPrefix)
    },
    var.default_tags,
    # var.vpc_tags,
  )
}
resource "aws_sagemaker_code_repository" "code_repository" {
  code_repository_name = "${var.envPrefix}-instance-code-repo"

  git_config {
    repository_url = var.repository_url
  }
}
resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "lc" {
  name      = "${var.envPrefix}-lifecycle-configuration"
  on_start = var.userdata
}
# fatal: could not read Username for 'https://github.com/sgs-dxc/test-sagemaker.git': terminal prompts disabled