# Roles starts here
resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.env_prefix}-codepipeline-role"
  assume_role_policy = file("${path.module}/templates/policies/codepipeline_role.json")
}

data "template_file" "codepipeline_policy" {
  template = file("${path.module}/templates/policies/codepipeline.json")

  vars = {
    aws_s3_bucket_arn = aws_s3_bucket.source.arn
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.template_file.codepipeline_policy.rendered
}

resource "aws_iam_role" "codebuild_role" {
  name               = "${var.env_prefix}-codebuild-role"
  assume_role_policy = file("${path.module}/templates/policies/codebuild_role.json")
}

data "template_file" "codebuild_policy" {
  template = file("${path.module}/templates/policies/codebuild_policy.json")

  vars = {
    aws_s3_bucket_arn = aws_s3_bucket.source.arn
  }
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "codebuild-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = data.template_file.codebuild_policy.rendered
}
############### End of roles ###########
resource "aws_s3_bucket" "source" {
  bucket        = lower("${var.env_prefix}-pipeline-ex")
  acl           = "private"
  force_destroy = true
}
resource "aws_codepipeline" "pipeline" {
  name     = "${var.env_prefix}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.source.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = var.source_git_provider_version
      output_artifacts = ["source"]

      configuration = {
        OAuthToken  = var.git_repository["github_oauth_token"]
        Owner       = var.git_repository["owner"]
        Repo        = var.git_repository["name"]
        Branch      = var.git_repository["branch"]
      }
    }
  }
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["imagedefinitions"]

      configuration = {
        ProjectName = "${var.env_prefix}-codebuild"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["imagedefinitions"]
      version         = "1"

      configuration = {
        ClusterName = var.cluster_name
        ServiceName = var.BService
        FileName    = "Dx-dev-test-APP.json"
      }
    }
  }
tags = var.default_tags
}
resource "aws_codebuild_project" "app_build" {
  name          = "${var.env_prefix}-codebuild"
  build_timeout = "60"

  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"

    // https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type            = "CODEPIPELINE"
    location        = "https://github.com/sgs-dxc/Test_fargate_source_code.git"
    git_clone_depth = 1
     }
    tags = var.default_tags
}
