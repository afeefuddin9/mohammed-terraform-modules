# Set the Terraform Cloud configuration.
terraform {
  cloud {
    organization = "dxc-dxpf"
    workspaces {
      name = "tf-aws-dxpf-portal-prod-pipeline"
    }
  }
}