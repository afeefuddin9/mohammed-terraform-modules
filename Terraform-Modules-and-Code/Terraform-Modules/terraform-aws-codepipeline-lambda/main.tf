# create a s3 bucket to store artifacts
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "${lower(var.env_prefix)}-artifact-bucket"
  acl           = "private"
  force_destroy = true
}

# set permissions on the s3 bucket
resource "aws_s3_bucket_public_access_block" "block_codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  restrict_public_buckets   = true
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
}

# reference to lambda codepipeline role created using tf-coreservices
data "aws_iam_role" "codepipeline_role" {
  name = "lambdabg-codepipeline-role"
}

# reference to a role for creating cloudformation stack created using tf-coreservices
data "aws_iam_role" "lambda_role" {
  name = "lambdabg-cfn-role"
}

# create codepipeline for deploying lambda functions
resource "aws_codepipeline" "codepipeline" {
  name     = "${var.env_prefix}-lambda-codepipeline"
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
        ProjectName = "LambdaBG-Build"
      }
    }
  }

  # define stage to create a cloudformation template and execute it to deploy lambda function
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      input_artifacts = ["BuildArtifact"]
      version         = "1"
      run_order       = "1"

      configuration = {
        ActionMode    = "CHANGE_SET_REPLACE",
        ChangeSetName = "${var.env_prefix}-lambda-changeset",
        Capabilities  = "CAPABILITY_IAM",
        StackName     = "${var.env_prefix}-lambda-stack",
        TemplatePath  = "BuildArtifact::outputtemplate.yml",
        RoleArn       = data.aws_iam_role.lambda_role.arn
      }
    }
    action {
      name            = "Execute-Changeset"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      input_artifacts = ["BuildArtifact"]
      version         = "1"
      run_order       = "2"

      configuration = {
        ActionMode    = "CHANGE_SET_EXECUTE",
        ChangeSetName = "${var.env_prefix}-lambda-changeset",
        StackName     = "${var.env_prefix}-lambda-stack"
      }
    }

  }

  # define stage to approve or reject deployment and invoke lambda function to swap aliases versions
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
      name      = "UpdateAlias"
      category  = "Invoke"
      owner     = "AWS"
      provider  = "Lambda"
      version   = "1"
      run_order = "2"

      configuration = {
        FunctionName   = "updateLambdaAliasBG",
        UserParameters = <<EOF
        {
         "StackName":"${var.env_prefix}-lambda-stack",
         "StageAliasName":"${var.StageAliasName}",
         "ProdAliasName":"${var.ProdAliasName}"
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
      name      = "UpdateAlias"
      category  = "Invoke"
      owner     = "AWS"
      provider  = "Lambda"
      version   = "1"
      run_order = "2"

      configuration = {
        FunctionName   = "updateLambdaAliasBG",
        UserParameters = <<EOF
        {
         "StackName":"${var.env_prefix}-lambda-stack",
         "StageAliasName":"${var.StageAliasName}",
         "ProdAliasName":"${var.ProdAliasName}"
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
  name            = "${var.env_prefix}-lambdabg-codepipeline-webhook"
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
