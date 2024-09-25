#-----------------------------------------------------------
# Global or/and default variables
#-----------------------------------------------------------
variable "name" {
  description = "Name to be used on all resources as prefix"
  default     = "TEST"
}

variable "environment" {
  description = "Environment for service"
  default     = "STAGE"
}

variable "tags" {
  description = "A list of tag blocks. Each element should have keys named key, value, etc."
  type        = map(string)
  default     = {}
}


# AWS Sagemaker model
#---------------------------------------------------
variable "enable_sagemaker_model" {
  description = "Enable sagemaker model usage"
  default     = false
}

variable "sagemaker_model_name" {
  description = "The name of the model (must be unique). If omitted, Terraform will assign a random, unique name."
  default     = ""
}

variable "sagemaker_model_execution_role_arn" {
  description = "(Required) A role that SageMaker can assume to access model artifacts and docker images for deployment."
  default     = null
}

variable "sagemaker_model_enable_network_isolation" {
  description = "(Optional) - Isolates the model container. No inbound or outbound network calls can be made to or from the model container."
  default     = null
}

variable "sagemaker_model_vpc_config" {
  description = "(Optional) - Specifies the VPC that you want your model to connect to. VpcConfig is used in hosting services and in batch transform."
  default     = []
}

variable "sagemaker_model_primary_container" {
  description = "(Optional) The primary docker image containing inference code that is used when the model is deployed for predictions. If not specified, the container argument is required. "
  default     = []
}

variable "sagemaker_model_container" {
  description = "(Optional) - Specifies containers in the inference pipeline. If not specified, the primary_container argument is required."
  default     = []
}


#---------------------------------------------------
# AWS Sagemaker endpoint configuration
#---------------------------------------------------
variable "enable_sagemaker_endpoint_configuration" {
  description = "Enable sagemaker endpoint configuration usage"
  default     = false
}

variable "sagemaker_endpoint_configuration_name" {
  description = "The name of the endpoint configuration. If omitted, Terraform will assign a random, unique name."
  default     = ""
}

variable "sagemaker_endpoint_configuration_kms_key_arn" {
  description = "(Optional) Amazon Resource Name (ARN) of a AWS Key Management Service key that Amazon SageMaker uses to encrypt data on the storage volume attached to the ML compute instance that hosts the endpoint."
  default     = null
}

variable "sagemaker_endpoint_configuration_production_variants" {
  description = "(Required) Fields for endpoint"
  default     = []
}

#---------------------------------------------------
# AWS Sagemaker endpoint
#---------------------------------------------------
variable "enable_sagemaker_endpoint" {
  description = "Enable sagemaker endpoint usage"
  default     = false
}

variable "sagemaker_endpoint_name" {
  description = "The name of the endpoint. If omitted, Terraform will assign a random, unique name."
  default     = null
}

variable "sagemaker_endpoint_endpoint_config_name" {
  description = "The name of the endpoint configuration to use."
  default     = ""
}

#---------------------------------------------------
# AWS sagemaker notebook instance lifecycle configuration
#---------------------------------------------------
variable "enable_sagemaker_notebook_instance_lifecycle_configuration" {
  description = "Enable sagemaker notebook instance lifecycle configuration usage"
  default     = false
}

variable "sagemaker_notebook_instance_lifecycle_configuration_name" {
  description = "The name of the lifecycle configuration (must be unique). If omitted, Terraform will assign a random, unique name."
  default     = null
}

variable "sagemaker_notebook_instance_lifecycle_configuration_on_create" {
  description = "(Optional) A shell script (base64-encoded) that runs only once when the SageMaker Notebook Instance is created."
  default     = null
}

variable "sagemaker_notebook_instance_lifecycle_configuration_on_start" {
  description = "(Optional) A shell script (base64-encoded) that runs every time the SageMaker Notebook Instance is started including the time it's created."
  default     = null
}

#---------------------------------------------------
# AWS Sagemaker notebook instance
#---------------------------------------------------
variable "enable_sagemaker_notebook_instance" {
  description = "Enable sagemaker notebook instance usage"
  default     = false
}

variable "sagemaker_notebook_instance_name" {
  description = "The name of the notebook instance (must be unique)."
  default     = ""
}

variable "sagemaker_notebook_instance_role_arn" {
  description = "(Required) The ARN of the IAM role to be used by the notebook instance which allows SageMaker to call other services on your behalf."
  default     = null
}

variable "sagemaker_notebook_instance_instance_type" {
  description = "(Required) The name of ML compute instance type."
  default     = "ml.t2.medium"
}

variable "sagemaker_notebook_instance_platform_identifier" {
  description = "(Optional) The platform identifier of the notebook instance runtime environment. This value can be either notebook-al1-v1, notebook-al2-v1, or notebook-al2-v2, depending on which version of Amazon Linux you require."
  default     = null
}

variable "sagemaker_notebook_instance_volume_size" {
  description = "(Optional) The size, in GB, of the ML storage volume to attach to the notebook instance. The default value is 5 GB."
  default     = 50
}

variable "sagemaker_notebook_instance_subnet_id" {
  description = "(Optional) The VPC subnet ID."
  default     = null
}

variable "sagemaker_notebook_instance_security_groups" {
  description = "(Optional) The associated security groups."
  default     = null
}

variable "sagemaker_notebook_instance_kms_key_id" {
  description = "(Optional) The AWS Key Management Service (AWS KMS) key that Amazon SageMaker uses to encrypt the model artifacts at rest using Amazon S3 server-side encryption."
  default     = null
}

variable "sagemaker_notebook_instance_lifecycle_config_name" {
  description = "(Optional) The name of a lifecycle configuration to associate with the notebook instance."
  default     = null
}

variable "sagemaker_notebook_instance_direct_internet_access" {
  description = "(Optional) Set to Disabled to disable internet access to notebook. Requires security_groups and subnet_id to be set. Supported values: Enabled (Default) or Disabled. If set to Disabled, the notebook instance will be able to access resources only in your VPC, and will not be able to connect to Amazon SageMaker training and endpoint services unless your configure a NAT Gateway in your VPC."
  default     = null
}

#---------------------------------------------------
# AWS Sagemaker user profile
#---------------------------------------------------
#variable "enable_sagemaker_user_profile" {
 # description = "Enable sagemaker user profile usage"
  #default     = true
#}




#---------------------------------------------------
# AWS Sagemaker domain
#---------------------------------------------------
variable "enable_sagemaker_domain" {
  description = "Enable sagemaker domain usage"
  default     = true
}

variable "sagemaker_domain_name" {
  description = "The domain name."
  default     = ""
}

variable "sagemaker_domain_auth_mode" {
  description = "(Required) The mode of authentication that members use to access the domain. Valid values are IAM and SSO"
  default     = null
}

variable "sagemaker_domain_vpc_id" {
  description = "(Required) The ID of the Amazon Virtual Private Cloud (VPC) that Studio uses for communication."
  default     = null
}

variable "sagemaker_domain_subnet_ids" {
  description = "(Required) The VPC subnets that Studio uses for communication."
  default     = null
}

variable "sagemaker_domain_kms_key_id" {
  description = "(Optional) The AWS KMS customer managed CMK used to encrypt the EFS volume attached to the domain."
  default     = null
}

variable "sagemaker_domain_app_network_access_type" {
  description = "(Optional) Specifies the VPC used for non-EFS traffic. The default value is PublicInternetOnly. Valid values are PublicInternetOnly and VpcOnly."
  default     = null
}

variable "sagemaker_domain_default_user_settings" {
  description = "(Required) The default user settings."
  default = {
    execution_role = null

    security_groups = null
  }
}



#---------------------------------------------------
# AWS sagemaker code repository
#---------------------------------------------------
variable "enable_sagemaker_code_repository" {
  description = "Enable sagemaker code repository usage"
  default     = true
}

variable "sagemaker_code_repository_name" {
  description = "The name of the Code Repository (must be unique)."
  default     = ""
}




