variable "default_tags" {
  type        = map(string)
  default     = {
    Project = "dxplatform"
    Managed = "Terraform"
    Owner   = "dxplatform"
    Billing = "dxplatform"
  }
  description = "tags defined to attach to resource"
}

variable "region" {
  type        = string
  default     = "ap-southeast-1"
  description = "AWS region"
}

variable "env_prefix" {
  type        = string
  default     = "DXPlatformPortal-Static-Staging"
  description = "Project prefix"
}

variable "deployment_config_name" {
  type        = string
  default     = "CodeDeployDefault.AllAtOnce"
  description = "deployment_config type for deploying to ec2 instances"
}

variable "deployment_option" {
  type        = string
  default     = "WITH_TRAFFIC_CONTROL"
  description = "to define loadbalancer requirement"
}

variable "deployment_type" {
  type        = string
  default     = "IN_PLACE"
  description = "defining deployment type"
}

variable "autoscaling_groups" {
  type        = list(string)
  #default     = ["DXPlatformPortal-Staging-ASG"] #Commenting the old ASG Name
  default     = ["dxplatformportal-stage-Asg"] #Adding the new ASG
  description = "autoscaling group names"
}

variable "target_group" {
  type        = string
  #default     = "PocDxinfraportalStaging-TG" #Commenting the old TG Name
  default     = "dxplatformportal-stage-TG01"  #Adding the new TG
  description = "target group name"
}

variable "trigger_events" {
  type        = list(string)
  default     = ["DeploymentSuccess","DeploymentFailure","DeploymentRollback","InstanceSuccess","InstanceFailure"]
  description = "trigger events to notify via SNS"
}

variable "alarms" {
  type        = list(string)
  default     = ["DXPFPlatformPortal-Static-Website-Alarm"]
  description = "cloudwatch alarm names"
}

variable "Owner" {
  type        = string
  default     = "sgs-dxc"
  description = "github user"
}

variable "Repo" {
  type        = string
  default     = "dx-platform-portal-static-website"
  description = "github repo name"
}

variable "Branch" {
  type        = string
  default     = "staging"
  description = "github branch for source code"
}