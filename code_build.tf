resource "aws_s3_bucket" "myCoolS3" {
  bucket        = local.bucketName
  force_destroy = true

}

resource "aws_iam_role" "role_for_codebuild" {
  name               = "example"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "policy_for_codebuild" {
  role = aws_iam_role.role_for_codebuild.name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [ #very insecure, don't do that
      {
        "Effect" : "Allow",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })

}

resource "aws_codebuild_project" "example" {
  name          = local.codeBuildProjectName
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.role_for_codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }


  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = local.codeBuildProjectName
      stream_name = "${local.codeBuildProjectName}IsVeryCool"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.myCoolS3.id}/build-log"
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = "https://git-codecommit.${local.default_region}.amazonaws.com/v1/repos/${local.codeCommitName}"
    git_clone_depth = 1
    git_submodules_config {
      fetch_submodules = true
    }
  }

  tags = {
    Environment = "Test"
  }

  depends_on = [aws_codecommit_repository.flask-repository]
}
