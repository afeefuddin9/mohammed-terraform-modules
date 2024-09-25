#Versions.tf and terraform workspace connection
terraform {
  required_version = ">= 1.7.5"
}

#Set the Terraform Cloud Configuration.
terraform {
  cloud {
    organization = "dxc-dxpf"
    workspaces {
      name = "tf-aws-dxpf-resources"
    }
  }
}