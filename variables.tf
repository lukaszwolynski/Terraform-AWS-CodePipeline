resource "random_string" "bucket_name" {
  length  = 16
  special = false
  upper   = false
}

locals {
  bucketName           = random_string.bucket_name.result
  codeCommitName       = "MyFlaskRepository"
  codeBuildProjectName = "MyBuildProject"
  default_region       = "eu-central-1"
}
