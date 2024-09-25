#!/bin/bash

# List of Git repository URLs
repos=(
    "https://github.com/sgs-dxc/terraform-aws-route53.git dev"
    "https://github.com/sgs-dxc/terraform-aws-glue.git"
    "https://github.com/sgs-dxc/terraform-aws-lambda.git"
    "https://github.com/sgs-dxc/terraform-aws-eks.git"
    "https://github.com/sgs-dxc/terraform-aws-vpc.git"
    "https://github.com/sgs-dxc/terraform-aws-dynamodb.git"
    "https://github.com/sgs-dxc/terraform-aws-ec2.git"
    "https://github.com/sgs-dxc/terraform-aws-alb.git"
    "https://github.com/sgs-dxc/terraform-aws-secret-manager.git"
    "https://github.com/sgs-dxc/terraform-aws-s3.git"
    "https://github.com/sgs-dxc/terraform-aws-apigateway-lambda.git"
    "https://github.com/sgs-dxc/terraform-aws-beanstalk.git"
    "https://github.com/sgs-dxc/terraform-aws-ecs-fargate.git"
    "https://github.com/sgs-dxc/terraform-aws-ecs.git"
    "https://github.com/sgs-dxc/terraform-aws-ec2-codepipeline.git"
    "https://github.com/sgs-dxc/terraform-aws-cloudwatch-notification.git"
    "https://github.com/sgs-dxc/terraform-aws-ASG.git"
    "https://github.com/sgs-dxc/terraform-aws-rds.git"
    "https://github.com/sgs-dxc/terraform-aws-sns-email.git"
    "https://github.com/sgs-dxc/terraform-aws-efs.git dev"
    "https://github.com/sgs-dxc/terraform-aws-sagemaker.git"
    "https://github.com/sgs-dxc/terraform-aws-DocumentDB.git"
    "https://github.com/sgs-dxc/terraform-aws-codepipeline-lambda.git"
    "https://github.com/sgs-dxc/terraform-aws-sqs.git"
    "https://github.com/sgs-dxc/terraform-aws-waf-ip-sets.git"
    "https://github.com/sgs-dxc/terraform-aws-ecs-fargate-codepipeline.git"
    "https://github.com/sgs-dxc/terraform-aws-codepipeline-ecs.git"
    "https://github.com/sgs-dxc/terraform-aws-codepipeline-beanstalk.git"
)

# # Directory to clone repositories into (optional)
# clone_dir="my_repos"

# # Create the directory if it doesn't exist
# mkdir -p "$clone_dir"

# # Change to the clone directory
# cd "$clone_dir" || exit

# Loop through each repository URL and clone it
for repo in "${repos[@]}"; do
    git clone "$repo"
done

echo "All repositories have been cloned successfully."
