#Adding variable for TF workspace
variable "region_oregon" {
  description = "This variable will fetch from terraform workspace"
  type        = string
}


variable "region_singapore" {
  description = "The AWS region for Singapore"
  type        = string
}
 

variable "vpc_ids_singapore" {
  description = "The ID of the VPC in the Singapore region"
  #type        = list(string)
  default     = [] #Adding blank vpc id for deleting for endpoint
  #default     = ["vpc-0873c29cd655a75b0","vpc-038e9a438ab205c10"] # VPC IDs for dxpf-loganalysis-pro Singapore region
} #commanding above vpc if to delete the endpoints