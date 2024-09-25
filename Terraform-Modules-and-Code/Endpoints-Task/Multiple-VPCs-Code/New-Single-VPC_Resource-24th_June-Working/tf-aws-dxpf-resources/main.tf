module "vpc_endpoints_us_west_2" {
  source = "./modules/vpc-endpoints-module/oregon-endpoints"
  region = var.region_oregon
  providers = {
    aws = aws.us_west_2
  }
}




module "vpc_endpoints_ap_southeast_1" {
  source    = "./modules/vpc-endpoints-module/singapore-endpoints"
  region    = var.region_singapore
  vpc_ids_singapore = var.vpc_ids_singapore
  providers = {
    aws = aws.ap_southeast_1
  }
}
