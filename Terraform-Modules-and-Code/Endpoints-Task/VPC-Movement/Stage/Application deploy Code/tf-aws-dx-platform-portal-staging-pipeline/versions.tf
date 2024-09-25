# Set the Terraform Cloud configuration.
terraform {
  cloud {
    organization = "dxc-dxpf"
    workspaces {
      #name = "tf-aws-dxpf-portal-stable-pipeline"
      name = "tf-aws-dx-platform-portal-staging-pipeline"
    }
  }
}