# Essensuous WAF Terraform module

Terraform module which creates Essensuous WAF IP Set on AWS.

These types of resources are supported:

* [WAF IpSets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_ipset)


## Terraform version
Terraform ~> 0.13.2

## Provider version
AWS Provider ~> 3.5.0

## Configuration Usage

```
# Provider Version Configuration
terraform {
  required_version = ">= 0.13.2"
  required_providers {
    aws = ">= 3.5.0"
  }
}
provider "aws" {
  region = "ap-northeast-1"
  ignore_tags {
    keys = ["Usage"]
  }
}
terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "768502287836-terraform-state-prod-ap-southeast-2"
    # Replace <applicationnameEnv> with your application key!
    key    = "Essensuous/terraform.tfstate"
    region = "ap-southeast-2"
    # Replace this with your DynamoDB table name!
   dynamodb_table = "terraform-state-lock-ap-southeast-1"
   encrypt        = true
  }
}
module "Essensuous_Dev" {
  #  source = "github.com/sgs-dxc/Essensuous-waf-Ip-Sets.git?ref=v1.0"
  source    = "./WAF"
  envPrefix = "EssensousDev"
  default_tags = {
    Project = "essensous"
    Managed = "Terraform"
    Owner   = "essensous"
    Billing = "essensous" # This tag should be set as project specific to better cost allocation
  }
  all_region_ipv4 = [
    # Region japan starts here 
    "114.179.36.144/28",
    "211.125.129.158/32",
    "211.125.129.237/32",
    "124.33.203.248/29",
    "133.138.4.7/32",
    "202.32.161.0/24",
    "182.171.67.227/32",
    "211.125.129.238/32",
    "211.125.129.239/32",
    "211.125.129.240/32",
    "211.125.129.166/32",
    "211.125.130.0/24",
    "211.125.136.0/24",
    "211.125.137.0/24",
    "211.125.138.0/24",
    "211.125.140.0/24",
    "202.32.161.13/32",
    "202.32.161.130/32",
    "202.213.234.1/32",
    "117.104.134.71/32",
    "103.123.139.0/26",
    # Region japan ends here
    #######################
    # Region AM(SIE) starts here
    "63.144.89.67/32",
    "63.144.89.66/32",
    "172.46.232.20/31",
    "173.230.196.15/32",
    "174.46.232.2/32",
    "98.6.164.221/32",
    "69.36.128.0/20",
    "69.36.130.0/23",
    "69.36.134.14/32",
    "50.200.6.186/32",
    "173.230.196.12/32",
    "100.42.96.0/20",
    "173.230.196.0/24",
    "100.42.98.196/32",
    "100.42.98.198/31",
    "100.42.98.25/32",
    "69.36.134.2/31",
    "69.36.134.12/31",
    "69.36.134.40/31",
    "69.36.134.10/31",
    "173.230.196.25/32",
    "69.36.134.42/31",
    "69.36.134.6/31",
    "177.94.213.253/32",
    "69.36.132.128/25",
    "69.36.132.252/31",
    "69.36.134.2/32",
    "173.230.196.16/32",
    "69.36.134.16/31",
    "12.39.184.125/32",
    "108.178.113.141/32",
    "69.174.84.138/32",
    "67.69.35.122/32",
    "174.46.232.0/26",
    "173.227.21.0/24",
    "69.36.134.8/31",
    "189.57.159.74/32",
    "69.36.132.124/31",
    "64.211.224.254/32",
    # Region AM(SIE) ends here
    #################
    # Region Japan SISC starts here
    "124.215.201.5/32",
    # Region Japan SISC ends here
    ############################
    # Region Japan SOMC starts here
    "125.16.140.48/29",
    # Region Japan SOMC ends here
    ############################
    # Region China starts here
    "58.32.209.43/32",
    "58.32.209.44/32",
    "58.32.209.45/32",
    "202.7.105.101/32",
    "219.142.53.236/32",
    "114.255.43.112/32",
    "37.139.156.40/32",
    "202.7.105.101/32",
    "101.230.83.192/27",
    # Region China ends here
    ############################
    # Region Taiwan starts here
    "43.70.33.102/32",
    "43.70.33.105/32",
    "61.62.10.102/32",
    # Region Taiwan ends here
    ############################
    # Region AP starts here
    "103.240.129.48/32",
    "103.240.129.49/32",
    "121.100.39.81/32",
    "121.100.39.83/32",
    "103.240.131.0/25",
    "103.240.131.0/24",
    "134.159.107.96/27",
    "203.126.19.192/28",
    "173.251.252.0/22",
    "42.61.37.0/25",
    # Region AP ends here
    ############################
    # Region Germany Berlin(SIE) starts here
    "185.48.97.4/32",
    "185.48.97.6/32",
    # Region Germany Berlin(SIE) ends here
    ############################
    # Region AM(SPE) starts here
    "208.84.227.0/24",
    "198.212.50.0/23",
    "173.251.128.0/18",
    "173.251.192.0/19",
    "173.251.224.0/20",
    "173.251.240.0/20",
    "208.84.224.0/22",
    # Region AM(SPE) ends here
    ############################
    # Region AM starts here
    "38.65.67.224/27",
    "97.105.9.72/29",
    "4.15.150.64/27",
    "4.15.150.128/27",
    # Region AM ends here
    ############################
    # Region AM(SEN) starts here
    "160.33.192.64/26",
    "67.24.140.0/24",
    "160.33.195.20/32",
    "160.33.195.21/32",
    "160.33.66.121/32",
    "160.33.66.122/32",
    "160.33.98.0/24",
    "160.33.168.61/32",
    "216.144.18.133/32",
    "216.144.18.134/32",
    # Region AM(SEN) ends here
    ############################
    # Region EU SPE starts here
    "213.152.248.128/27",
    "173.251.248.0/22",
    "185.64.36.128/25",
    "195.2.41.0/27",
    "195.2.41.10/32",
    "217.18.17.0/24",
    "217.18.20.0/24",
    "217.18.21.0/24",
    "217.18.23.0/24",
    "193.102.74.0/24",
    "193.178.208.0/24",
    # Region EU SPE ends here
    ############################
    # Region HK starts here
    "202.182.225.254/32",
    "134.159.107.96/28",
    # Region HK ends here
    ############################
    # Region South Korea starts here
    "218.55.27.8/32",
    "218.55.27.9/32",
    "218.55.27.10/32",
    "218.55.27.14/32",
    "222.231.52.2/32",
    # Region South Korea ends here
    ############################
    # Region UK starts here
    "49.255.45.94/32",
    "185.48.97.9/32",
    "49.255.45.98/32",
    "213.161.89.16/28",
    "203.16.196.0/24"
    # Region UK ends here
  ]
  all_region_ipv6 = [
    # Region japan starts here 
    "2001:cf8:0:653::237/128",
    "2001:cf8:0:653::238/128",
    "2001:cf8:0:653::239/128",
    "2001:cf8:0:653::240/128",
    "2400:4104:400::/48",
    "2001:cf8:ace:40::/64",
    "2001:cf8:ace:41::/64",
    "2001:cf8:ace:42::/124",
    "2001:cf8:0:50::/60",
    "2001:cf8:0:60::/60",
    "2001:cf8:0:b0::/64",
    "2001:cf8:ace:30::/64",
    "2001:df0:266::/52",
    "2001:df0:266:a000::/52",
    # Region japan ends here 
    #######################
    # Region AP starts here
    "2400:3c00:0:8a4::48/128",
    "2400:3c00:0:8a4::49/128",
    "2400:3c00:1::48/128",
    "2400:3c00:0:174::81/128",
    "2400:3c00:0:174::83/128",
    # Region AP ends here
    #######################
    # Region AM(SEN) starts here
    "2607:fd28:11::/64",
    "2607:fd28:0:16::/64",
    "2607:fd28:1::/48",
    "2607:fd28:a000:201::/64",
    "2607:fd28:a000:22a::20/128",
    "2607:fd28:a000:22a::21/128",
    "2607:fd28:a004:20d::121/128",
    "2607:fd28:a004:20d::122/128",
    # Region AM(SEN) ends here
    #######################
    # Region EU(SPE) starts here
    "2a00:1310::/32"
    # Region AM(SEN) ends here
  ]
}
module "Essensuous_Prod" {
  #  source = "github.com/sgs-dxc/Essensuous-waf-Ip-Sets.git?ref=v1.0"
  source    = "./WAF"
  envPrefix = "EssensousProd"
  default_tags = {
    Project = "essensous"
    Managed = "Terraform"
    Owner   = "essensous"
    Billing = "essensous" # This tag should be set as project specific to better cost allocation
  }
  all_region_ipv4 = [
    # Region japan starts here 
    "114.179.36.144/28",
    "211.125.129.158/32",
    "211.125.129.237/32",
    "124.33.203.248/29",
    "133.138.4.7/32",
    "202.32.161.0/24",
    "182.171.67.227/32",
    "211.125.129.238/32",
    "211.125.129.239/32",
    "211.125.129.240/32",
    "211.125.129.166/32",
    "211.125.130.0/24",
    "211.125.136.0/24",
    "211.125.137.0/24",
    "211.125.138.0/24",
    "211.125.140.0/24",
    "202.32.161.13/32",
    "202.32.161.130/32",
    "202.213.234.1/32",
    "117.104.134.71/32",
    "103.123.139.0/26",
    # Region japan ends here
    #######################
    # Region AM(SIE) starts here
    "63.144.89.67/32",
    "63.144.89.66/32",
    "172.46.232.20/31",
    "173.230.196.15/32",
    "174.46.232.2/32",
    "98.6.164.221/32",
    "69.36.128.0/20",
    "69.36.130.0/23",
    "69.36.134.14/32",
    "50.200.6.186/32",
    "173.230.196.12/32",
    "100.42.96.0/20",
    "173.230.196.0/24",
    "100.42.98.196/32",
    "100.42.98.198/31",
    "100.42.98.25/32",
    "69.36.134.2/31",
    "69.36.134.12/31",
    "69.36.134.40/31",
    "69.36.134.10/31",
    "173.230.196.25/32",
    "69.36.134.42/31",
    "69.36.134.6/31",
    "177.94.213.253/32",
    "69.36.132.128/25",
    "69.36.132.252/31",
    "69.36.134.2/32",
    "173.230.196.16/32",
    "69.36.134.16/31",
    "12.39.184.125/32",
    "108.178.113.141/32",
    "69.174.84.138/32",
    "67.69.35.122/32",
    "174.46.232.0/26",
    "173.227.21.0/24",
    "69.36.134.8/31",
    "189.57.159.74/32",
    "69.36.132.124/31",
    "64.211.224.254/32",
    # Region AM(SIE) ends here
    #################
    # Region Japan SISC starts here
    "124.215.201.5/32",
    # Region Japan SISC ends here
    ############################
    # Region Japan SOMC starts here
    "125.16.140.48/29",
    # Region Japan SOMC ends here
    ############################
    # Region China starts here
    "58.32.209.43/32",
    "58.32.209.44/32",
    "58.32.209.45/32",
    "202.7.105.101/32",
    "219.142.53.236/32",
    "114.255.43.112/32",
    "37.139.156.40/32",
    "202.7.105.101/32",
    "101.230.83.192/27",
    # Region China ends here
    ############################
    # Region Taiwan starts here
    "43.70.33.102/32",
    "43.70.33.105/32",
    "61.62.10.102/32",
    # Region Taiwan ends here
    ############################
    # Region AP starts here
    "103.240.129.48/32",
    "103.240.129.49/32",
    "121.100.39.81/32",
    "121.100.39.83/32",
    "103.240.131.0/25",
    "103.240.131.0/24",
    "134.159.107.96/27",
    "203.126.19.192/28",
    "173.251.252.0/22",
    "42.61.37.0/25",
    # Region AP ends here
    ############################
    # Region Germany Berlin(SIE) starts here
    "185.48.97.4/32",
    "185.48.97.6/32",
    # Region Germany Berlin(SIE) ends here
    ############################
    # Region AM(SPE) starts here
    "208.84.227.0/24",
    "198.212.50.0/23",
    "173.251.128.0/18",
    "173.251.192.0/19",
    "173.251.224.0/20",
    "173.251.240.0/20",
    "208.84.224.0/22",
    # Region AM(SPE) ends here
    ############################
    # Region AM starts here
    "38.65.67.224/27",
    "97.105.9.72/29",
    "4.15.150.64/27",
    "4.15.150.128/27",
    # Region AM ends here
    ############################
    # Region AM(SEN) starts here
    "160.33.192.64/26",
    "67.24.140.0/24",
    "160.33.195.20/32",
    "160.33.195.21/32",
    "160.33.66.121/32",
    "160.33.66.122/32",
    "160.33.98.0/24",
    "160.33.168.61/32",
    "216.144.18.133/32",
    "216.144.18.134/32",
    # Region AM(SEN) ends here
    ############################
    # Region EU SPE starts here
    "213.152.248.128/27",
    "173.251.248.0/22",
    "185.64.36.128/25",
    "195.2.41.0/27",
    "195.2.41.10/32",
    "217.18.17.0/24",
    "217.18.20.0/24",
    "217.18.21.0/24",
    "217.18.23.0/24",
    "193.102.74.0/24",
    "193.178.208.0/24",
    # Region EU SPE ends here
    ############################
    # Region HK starts here
    "202.182.225.254/32",
    "134.159.107.96/28",
    # Region HK ends here
    ############################
    # Region South Korea starts here
    "218.55.27.8/32",
    "218.55.27.9/32",
    "218.55.27.10/32",
    "218.55.27.14/32",
    "222.231.52.2/32",
    # Region South Korea ends here
    ############################
    # Region UK starts here
    "49.255.45.94/32",
    "185.48.97.9/32",
    "49.255.45.98/32",
    "213.161.89.16/28",
    "203.16.196.0/24"
    # Region UK ends here
  ]

  all_region_ipv6 = [
    # Region japan starts here 
    "2001:cf8:0:653::237/128",
    "2001:cf8:0:653::238/128",
    "2001:cf8:0:653::239/128",
    "2001:cf8:0:653::240/128",
    "2400:4104:400::/48",
    "2001:cf8:ace:40::/64",
    "2001:cf8:ace:41::/64",
    "2001:cf8:ace:42::/124",
    "2001:cf8:0:50::/60",
    "2001:cf8:0:60::/60",
    "2001:cf8:0:b0::/64",
    "2001:cf8:ace:30::/64",
    "2001:df0:266::/52",
    "2001:df0:266:a000::/52",
    # Region japan ends here 
    #######################
    # Region AP starts here
    "2400:3c00:0:8a4::48/128",
    "2400:3c00:0:8a4::49/128",
    "2400:3c00:1::48/128",
    "2400:3c00:0:174::81/128",
    "2400:3c00:0:174::83/128",
    # Region AP ends here
    #######################
    # Region AM(SEN) starts here
    "2607:fd28:11::/64",
    "2607:fd28:0:16::/64",
    "2607:fd28:1::/48",
    "2607:fd28:a000:201::/64",
    "2607:fd28:a000:22a::20/128",
    "2607:fd28:a000:22a::21/128",
    "2607:fd28:a004:20d::121/128",
    "2607:fd28:a004:20d::122/128",
    # Region AM(SEN) ends here
    #######################
    # Region EU(SPE) starts here
    "2a00:1310::/32"
    # Region AM(SEN) ends here
  ]
}
```hcl

## Usage

To run this module you need to execute:

```bash
$ terraform init
$ terraform plan -out "plan.out"
$ terraform apply "plan.out"
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.13.2 |
| aws | ~> 3.5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.5.0 |

## Autoscaling group Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| envPrefix | Define the environment prefix | `string` | n/a | yes |
| jp_cidr_ipv4 | Define the list of JP IPv4 cidr | `list(string)` | n/a | yes |
| jp_cidr_ipv6 | Define the list of JP IPv6 cidr | `list(string)` | n/a | yes |
| AM_SIE_cidr_ipv4 | Define the list of AM SIE IPv4 cidr | `list(string)` | n/a | yes |
| jp_SOMC_cidr_ipv4 | Define the list of JP SOMC IPv4 cidr | `list(string)` | n/a | yes |
| jp_SISC_cidr_ipv4 | Define the list of JP SISC IPv4 cidr | `list(string)` | n/a | yes |
| CN_cidr_ipv4 | Define the list of CN IPv4 cidr | `list(string)` | n/a | yes |
| TW_cidr_ipv4 | Define the list of TW IPv4 cidr | `list(string)` | n/a | yes |
| AP_cidr_ipv6 | Define the list of AP IPv6 cidr | `list(string)` | n/a | yes |
| AP_cidr_ipv4 | Define the list of AP IPv4 cidr | `list(string)` | n/a | yes |
| AM_SEN_cidr_ipv4 | Define the list of AM SEN IPv4 cidr | `list(string)` | n/a | yes |
| AM_SEN_cidr_ipv6 | Define the list of AM SEN IPv6 cidr | `list(string)` | n/a | yes |
| AM_SPE_cidr_ipv4 | Define the list of AM SPE IPv4 cidr | `list(string)` | n/a | yes |
| AM_cidr_ipv4 | Define the list of AM IPv4 cidr | `list(string)` | n/a | yes |
| Germany_Berlin_SIE_cidr_ipv4 | Define the list of Germany_Berlin_SIE IPv4 cidr | `list(string)` | n/a | yes |
| EU_SPE_cidr_ipv4 | Define the list of EU SPE IPv4 cidr | `list(string)` | n/a | yes |
| EU_SPE_cidr_ipv6 | Define the list of EU SPE IPv4 cidr | `list(string)` | n/a | yes |
| HK_cidr_ipv4 | Define the list of HK IPv4 cidr | `list(string)` | n/a | yes |
| south_korea_cidr_ipv4 | Define the list of korea IPv4 cidr | `list(string)` | n/a | yes |
| UK_cidr_ipv4 | Define the list of UK IPv4 cidr | `list(string)` | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
