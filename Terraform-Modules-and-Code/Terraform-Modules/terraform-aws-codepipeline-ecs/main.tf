# create s3 bucket to store artifacts
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "${lower(var.env_prefix)}-artifact-bucket"
  acl           = "private"
  force_destroy = true
}

# set permissions on the s3 bucket
resource "aws_s3_bucket_public_access_block" "block_codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
}

# reference to ecs codepipeline role created via tf-coreservices
data "aws_iam_role" "codepipeline_role" {
  name = "ecsbg-codepipeline-role"
}

# reference to s3 bucket consisting of deploy script
data "aws_s3_bucket" "ecsbg_scriptbucket" {
  bucket = "ecsbg-scriptbucket"
}

# create codepipeline to deploy containers on ecs/fargate
resource "aws_codepipeline" "codepipeline" {
  name     = "${var.env_prefix}-ecs-codepipeline"
  role_arn = data.aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"

  }

  # define stage for source code and deploy script
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      run_order        = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        OAuthToken           = var.OAuthToken
        Owner                = var.Owner
        Repo                 = var.Repo
        Branch               = var.Branch
        PollForSourceChanges = "false"
      }
    }

    action {
      name             = "GetDeployScripts"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      run_order        = "1"
      output_artifacts = ["DeployScripts"]

      configuration = {
        S3Bucket             = data.aws_s3_bucket.ecsbg_scriptbucket.bucket
        PollForSourceChanges = "false"
        S3ObjectKey          = "ECS_Deploy_Scripts.zip"
      }
    }
  }

  # define stage to create new image and push it to ecr
  stage {
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
        ProjectName          = "ECSBG-UploadImage-To-ECR",
        EnvironmentVariables = <<EOF
        [{
         "name": "REPOSITORY_URI",
         "value": "${var.repository_uri}",
         "type": "PLAINTEXT"
        }]
        EOF

      }
    }
  }
  # define stage to update task defn and service using codebuild project
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["BuildArtifact", "DeployScripts"]
      version         = "1"
      run_order       = "1"

      configuration = {
        ProjectName          = "ECSBG-Update-ECS-Service",
        PrimarySource        = "BuildArtifact",
        EnvironmentVariables = <<EOF
        [{
         "name": "TASK_NAME",
         "value": "${var.TaskName}",
         "type": "PLAINTEXT"
        },
        {
         "name": "CLUSTER_NAME",
         "value": "${var.ClusterName}",
         "type": "PLAINTEXT"
        },
        {
         "name": "BLUESERVICE",
         "value": "${var.BService}",
         "type": "PLAINTEXT"
        },
        {
         "name": "GREENSERVICE",
         "value": "${var.GService}",
         "type": "PLAINTEXT"
        }]
        EOF
      }
    }
  }

  # define stage to approve or reject deployment and invoke lambda function to swap alb listener target group
  stage {
    name = "ManageRelease"

    action {
      name      = "ApproveRelease"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
      run_order = "1"

      configuration = {
        CustomData = "Approve Release"
      }
    }
    action {
      name      = "SwapTargetGroup"
      category  = "Invoke"
      owner     = "AWS"
      provider  = "Lambda"
      version   = "1"
      run_order = "2"

      configuration = {
        FunctionName   = "swapECSALBTG",
        UserParameters = <<EOF
        {
         "ElbName":"${var.ElbName}",
         "ClusterName":"${var.ClusterName}",
         "BService":"${var.BService}",
         "GService":"${var.GService}"
        }
        EOF
      }
    }
  }
  # define stage to rollback
  stage {
    name = "ManageRollback"

    action {
      name      = "ApproveRollback"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
      run_order = "1"

      configuration = {
        CustomData = "Approve Rollback"
      }
    }
    action {
      name      = "SwapTargetGroup"
      category  = "Invoke"
      owner     = "AWS"
      provider  = "Lambda"
      version   = "1"
      run_order = "2"

      configuration = {
        FunctionName   = "swapECSALBTG",
        UserParameters = <<EOF
        {
         "ElbName":"${var.ElbName}",
         "ClusterName":"${var.ClusterName}",
         "BService":"${var.BService}",
         "GService":"${var.GService}"
        }
        EOF
      }
    }
  }
  tags = merge(
    var.default_tags,
    # var.other_tags,
  )
}

# create a webhook in codepipeline
resource "aws_codepipeline_webhook" "codepipeline_webhook" {
  name            = "${var.env_prefix}-ecsbg-codepipeline-webhook"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.codepipeline.name

  authentication_configuration {
    secret_token = var.OAuthToken
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}

# wire the CodePipeline webhook into a GitHub repository
resource "github_repository_webhook" "repository_webhook" {
  repository = var.Repo


  configuration {
    url          = aws_codepipeline_webhook.codepipeline_webhook.url
    content_type = "json"
    insecure_ssl = true
    secret       = var.OAuthToken
  }

  events = ["push"]
}

provider "github" {
  token        = var.OAuthToken
  organization = var.Owner
}
