/*
data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    bucket = "tfstate-dx-platform-portal"
    key    = "terraform.tfstate"
    region = "ap-southeast-1"
  }
}

*/

data "terraform_remote_state" "alb" {
  backend = "remote"

  config = {
    organization = "dxc-dxpf"
    workspaces = {
      #name = "tf-aws-dxplatform-portal"
      name = "tf-aws-dxplatform-portal-prod"
    }
  }
}



