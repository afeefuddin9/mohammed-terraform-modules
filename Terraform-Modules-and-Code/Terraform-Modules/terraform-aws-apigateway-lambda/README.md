# API Gateway and Lambda deployment by Terraform 

Terraform module for API Gateway and Lambda deployment resources on AWS.

These types of resources are supported:

* [API Gateway](https://www.terraform.io/docs/providers/aws/r/launch_configuration.html)
* [Lambda](https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html)

## Terraform version
Terraform ~> 0.13.2

## Provider version
AWS Provider ~> 3.5.0

## Configuration Usage

```hcl
# local variables ######
# default_tags
#      - include or exclude tags as per the requirements

locals {
  api_gateway_name    = "Hello Terraform API Gateway"
  env_prefix          = "tfdemoapigateway"
  project_description = "API Gateway demo created by Terraform"
  deployment_type     = "pro"
  default_tags = {
    Project = "tfdemoapigateway"
    Owner   = "DxInfra"
    Billing = "DxInfra"
  }
}
# Provider Version Configuration
terraform {
  required_version = ">= 0.13.2"
  required_providers {
    aws = ">= 3.5.0"
  }
}

#AWS region and terraform version
provider "aws" {
  region  = "${var.aws_region}"
  version = "~> 3.5.0"
}

#Terraform statefile stores to s3.
terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "dxportalstage-tfstate-bucket"
    key    = "tfapigatewaydemo/terraform.tfstate"
    region = "ap-southeast-2"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "dxportalstage-locks"
    encrypt        = true
  }
}

data "aws_caller_identity" "current" {}

# First, we need a role to play with Lambda
resource "aws_iam_role" "tfdemo_iam_role_for_apigateway_lambda" {
  name = "tfdemo_iam_role_for_apigateway_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_api_gateway_api_key" "api_gateway_usage_plan_apiKey" {
  name        = local.env_prefix
  description = local.project_description
  tags        = local.default_tags
}


# Here is a first lambda function that will run the code `hello_lambda.handler`
module "lambda" {
  source  = "./lambda"
  name    = "hellolambda_demov1"
  runtime = "python2.7"
  role    = "${aws_iam_role.tfdemo_iam_role_for_apigateway_lambda.arn}"
}

# This is a second lambda function that will run the code
# `hello_lambda.post_handler`
module "lambda_post" {
  source  = "./lambda"
  name    = "hellolambda_demov1"
  handler = "post_handler"
  runtime = "python2.7"
  role    = "${aws_iam_role.tfdemo_iam_role_for_apigateway_lambda.arn}"
}

# Now, we need an API to expose those functions publicly
resource "aws_api_gateway_rest_api" "hello_api" {
  name        = local.api_gateway_name
  description = "API Demo created by Terraform"
  tags        = local.default_tags
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# The API requires at least one "endpoint", or "resource" in AWS terminology.
# The endpoint created here is: /hello
resource "aws_api_gateway_resource" "hello_api_res_hello" {
  rest_api_id = "${aws_api_gateway_rest_api.hello_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.hello_api.root_resource_id}"
  path_part   = "hello"
}

# Until now, the resource created could not respond to anything. We must set up
# a HTTP method (or verb) for that!
# This is the code for method GET /hello, that will talk to the first lambda
module "hello_get" {
  source      = "./api_method"
  rest_api_id = "${aws_api_gateway_rest_api.hello_api.id}"
  resource_id = "${aws_api_gateway_resource.hello_api_res_hello.id}"
  method      = "GET"
  path        = "${aws_api_gateway_resource.hello_api_res_hello.path}"
  lambda      = "${module.lambda.name}"
  region      = "${var.aws_region}"
  account_id  = "${data.aws_caller_identity.current.account_id}"
}

# This is the code for method POST /hello, that will talk to the second lambda
module "hello_post" {
  source      = "./api_method"
  rest_api_id = "${aws_api_gateway_rest_api.hello_api.id}"
  resource_id = "${aws_api_gateway_resource.hello_api_res_hello.id}"
  method      = "POST"
  path        = "${aws_api_gateway_resource.hello_api_res_hello.path}"
  lambda      = "${module.lambda_post.name}"
  region      = "${var.aws_region}"
  account_id  = "${data.aws_caller_identity.current.account_id}"
}

# Deploy the API now! (i.e. make it publicly available)
resource "aws_api_gateway_deployment" "hello_api_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.hello_api.id}"
  stage_name  = "production"
  description = "Deploy methods: ${module.hello_get.http_method} ${module.hello_post.http_method}"
}

#Create the API Usage plan and assigned to API.
resource "aws_api_gateway_usage_plan" "api_gateway_usage_plan" {
  name        = local.env_prefix
  description = local.project_description
  #product_code = "MYCODE"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.hello_api.id}"
    stage  = "${aws_api_gateway_deployment.hello_api_deployment.stage_name}"
  }

  /*
  api_stages {
    api_id = "${aws_api_gateway_rest_api.myapi.id}"
    stage  = "${aws_api_gateway_deployment.prod.stage_name}"
  }
*/

  /* quota_settings {
    limit  = 20
    offset = 2
    period = "WEEK"
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }*/
}
# Assign the API_Key to usage plan.
resource "aws_api_gateway_usage_plan_key" "usage_plan_api_key" {
  key_id        = "${aws_api_gateway_api_key.api_gateway_usage_plan_apiKey.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.api_gateway_usage_plan.id}"
}
```

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

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS Region where resources should be created | `string` | `""` | Yes |
| rest_api_id | The ID of the associated REST API | `string` | `""` | Yes |
| resource_id | The API resource ID | `string` | `""` | Yes |
| method | The HTTP method | `string` | `""` | Yes |
| path | The API resource path | `string` | `""` | Yes |
| lambda | The lambda name to invoke | `string` | `""` | Yes |
| region | The AWS region, e.g., | `string` | `""` | Yes |
| account_id | The AWS account ID | `string` | `""` | Yes |
| name | The name of the lambda to create, which also defines (i) the archive name (.zip), (ii) the file name, and (iii) the function name | `string` | `""` | Yes |
| runtime | The runtime of the lambda to create  | `string` | `""` | Yes |
| handler | The handler name of the lambda (a function defined in your lambda) | `string` | `""` | Yes |
| role | IAM role attached to the Lambda Function (ARN) | `string` | `""` | Yes |

## Outputs
| Name | Description |
|------|-------------|
| http_method | HTTP method of API gateway |
| name | The Lambda function name |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Sony DXC Platform](https://).
