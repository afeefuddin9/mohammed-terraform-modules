#Mail.tf file calling for Oregon Region
module "vpc_endpoints_us_west_2" {
  source    = "./modules/vpc-endpoints-module"
  region    = var.region_oregon
  providers = {
    aws = aws.us_west_2
  }
}

#Mail.tf file calling for Singapore Region
# module "vpc_endpoints_ap_southeast_1" {
#   source    = "./modules/vpc-endpoints-module"
#   region    = var.region_singapore
#   providers = {
#     aws = aws.ap_southeast_1
#   }
# }

# #Mail.tf file calling for Tokyo Region
# module "vpc_endpoints_ap_northeast_1" {
#   source    = "./modules/vpc-endpoints-module"
#   region    = var.region_tokyo
#   providers = {
#     aws = aws.ap_northeast_1
#   }
# }

