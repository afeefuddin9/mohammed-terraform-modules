# main.tf

module "vpc_endpoints_us_west_2" {
  source = "./modules/vpc-endpoints-module"
  region = "us-west-2"
}

module "vpc_endpoints_ap_southeast_1" {
  source = "./modules/vpc-endpoints-module"
  region = "ap-southeast-1"
}
