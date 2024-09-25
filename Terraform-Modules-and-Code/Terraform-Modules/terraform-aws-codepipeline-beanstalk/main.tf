# create a s3 bucket to store artifacts
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "${lower(var.env_prefix)}-codepipeline-bucket"
  acl           = "private"
  force_destroy = true

  tags = merge(
    var.default_tags,
    # var.vpc_tags,
  )
}

# set permissions on the s3 bucket
resource "aws_s3_bucket_public_access_block" "block_codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  restrict_public_buckets   = true
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
}

# reference to beanstalk codepipeline role created using tf-coreservices
data "aws_iam_role" "codepipeline_role" {
  name = "beanstalkbg-codepipeline-role"
}

# create codepipeline for deploying applications on beanstalk
resource "aws_codepipeline" "codepipeline" {
  name = "${var.env_prefix}-codepipeline"
  #role_arn = "${aws_iam_role.codepipeline_role.arn}"
  role_arn = data.aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"

  }

  # define stage for source code
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

  }

  # define stage for creating build
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
        ProjectName = "BeanstalkBG-Build"
      }
    }
  }

  # define stage to invoke lambda function to deploy application
  stage {
    name = "Deploy"

    action {
      name            = "Deploy-App-On-StgEnv"
      category        = "Invoke"
      owner           = "AWS"
      provider        = "Lambda"
      input_artifacts = ["BuildArtifact"]
      version         = "1"
      run_order       = "1"

      configuration = {
        FunctionName   = "deployBeanstalkBGApp",
        UserParameters = <<EOF
        {
          "Env1":"${var.env_1}",
          "Env2":"${var.env_2}",
          "AppName":"${var.app}"
        }
        EOF
      }
    }
  }

  # define stage to approve or reject deployment and invoke lambda function to swap cname
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
      name      = "SwapEnvURL"
      category  = "Invoke"
      owner     = "AWS"
      provider  = "Lambda"
      version   = "1"
      run_order = "2"

      configuration = {
        FunctionName   = "swapBeanstalkBGEnvURL",
        UserParameters = <<EOF
        {
          "Env1":"${var.env_1}",
          "Env2":"${var.env_2}"
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
      name      = "SwapEnvURL"
      category  = "Invoke"
      owner     = "AWS"
      provider  = "Lambda"
      version   = "1"
      run_order = "2"

      configuration = {
        FunctionName   = "swapBeanstalkBGEnvURL",
        UserParameters = <<EOF
        {  
          "Env1":"${var.env_1}",
          "Env2":"${var.env_2}"
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

# codepipeline webhook
resource "aws_codepipeline_webhook" "codepipeline_webhook" {
  name            = "${var.env_prefix}-codepipeline-webhook"
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
  tags = merge(
    var.default_tags,
    # var.other_tags,
  )
}

# wire the codepipeline webhook into a GitHub repository
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
