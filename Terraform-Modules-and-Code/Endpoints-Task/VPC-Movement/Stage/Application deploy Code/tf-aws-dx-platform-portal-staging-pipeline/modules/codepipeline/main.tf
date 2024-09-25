#codepipeline template for ec2(autoscaling) based deployment
#create codebuild project for EC2
/*resource "aws_codebuild_project" "codebuild_project" {
  name          = "${var.env_prefix}-codebuild-project"
  description   = "codebuild_project for ${var.env_prefix}"
  build_timeout = "5"
  service_role  = var.codebuild_role

  artifacts {
    type                   = "CODEPIPELINE"
    override_artifact_name = false
  }

  cache {
    type     = "S3"
    location = var.s3_bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

  }

  source {
    type            = "CODEPIPELINE"
    git_clone_depth = 0

    git_submodules_config {
      fetch_submodules = false
    }
  }
}
*/
# create codedeploy application for EC2
resource "aws_codedeploy_app" "codedeploy_application" {
  compute_platform = "Server"
  name             = "${var.env_prefix}-codedeploy-app"
}

#create codedeploy deployment group
resource "aws_codedeploy_deployment_group" "codedeploy_deployment_group" {
  app_name               = aws_codedeploy_app.codedeploy_application.name
  deployment_group_name  = "${var.env_prefix}-deployment-group"
  service_role_arn       = var.codedeploy_role
  deployment_config_name = var.deployment_config_name

  deployment_style {
    deployment_option = var.deployment_option
    deployment_type   = var.deployment_type
  }

  #If deployment is based on ec2 instance tags
  /*ec2_tag_filter {
    key   = var.ec2_tag_key
    type  = "KEY_AND_VALUE"
    value = var.ec2_tag_value
  }
  */
  #If autoscaling configured for this pipeline, mention ASG names
  autoscaling_groups  = var.autoscaling_groups
  
  load_balancer_info {
    target_group_info {
      name = var.target_group
    }
  }

  trigger_configuration {
    trigger_events     = var.trigger_events
    trigger_name       = "${var.env_prefix}-trigger"
    trigger_target_arn = var.sns_topic_arn
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  alarm_configuration {
    alarms  = var.alarms
    enabled = true
  }
}

# create codepipeline for deploying applications on EC2
resource "aws_codepipeline" "codepipeline" {
  name = "${var.env_prefix}-codepipeline"
  role_arn = var.codepipeline_role

  artifact_store {
    location = var.s3_bucket
    type     = "S3"

  }

  # define stage for source code
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = var.source_git_provider_version
      run_order        = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        #ConnectionArn=aws_codestarconnections_connection.GitHubConnection.arn
        ConnectionArn    = "arn:aws:codestar-connections:ap-southeast-1:768502287836:connection/16b0da48-6cce-4829-9ade-df5d2a5da155"
        FullRepositoryId = "${var.Owner}/${var.Repo}"
        BranchName           = var.Branch
        OutputArtifactFormat = "CODE_ZIP"
        # OAuthToken           = var.OAuthToken
        # Owner                = var.Owner
        # Repo                 = var.Repo
        # Branch               = var.Branch
        # PollForSourceChanges = "true"
      }

    }

  }

  # define stage for creating build
  /*stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"
      run_order        = "1"

      configuration = {
        ProjectName = aws_codebuild_project.codebuild_project.name
      }
    }
  }
  */
  #define stage for deployment
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["SourceArtifact"] #If build stage is using, make this field as "BuildArtifact"
      version         = "1"

      configuration = {
        ApplicationName       = aws_codedeploy_app.codedeploy_application.name
        DeploymentGroupName   = aws_codedeploy_deployment_group.codedeploy_deployment_group.deployment_group_name  
      }
    }
  }
  tags = var.default_tags
}

# resource "aws_codestarconnections_connection" "GitHubConnection" {
#   name          = var.env_prefix
#   provider_type = "GitHub"
# }
