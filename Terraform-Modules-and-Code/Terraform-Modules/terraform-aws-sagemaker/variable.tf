variable "envPrefix" {

}
variable "instance_type" {
default = "ml.t2.medium"
}
variable "volume_size" {
default = "5"
}
variable "subnet_id" {

}
variable "security_groups" {

}
variable "create_lifecycle_config" {
default = false
}
variable "attach_code_repo" {
default = false
}
variable "default_tags" {

}
variable "role_arn" {
}
variable "repository_url" {
default = ""
}
variable "default_code_repository" {
default = ""
}
variable "userdata" {
    
}