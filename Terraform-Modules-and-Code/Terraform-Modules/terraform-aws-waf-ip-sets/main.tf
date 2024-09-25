# Get the current AWS accountid
data "aws_caller_identity" "current" {}

# Create WAF version 2 
resource "aws_wafv2_ip_set" "jp_cidr_ipv4" {
  name               = "${var.envPrefix}_IPV4_IpSets"
  description        = "This IP set contains the ipv4 addresses of all the available regions"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.all_region_ipv4
  tags               = var.default_tags
}
resource "aws_wafv2_ip_set" "jp_cidr_ipv6" {
  name               = "${var.envPrefix}_IPV6_IpSets"
  description        = "This IP set contains the ipv4 addresses of all the available regions"
  scope              = "REGIONAL"
  ip_address_version = "IPV6"
  addresses          = var.all_region_ipv6
  tags               = var.default_tags
}
