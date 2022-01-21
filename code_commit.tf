resource "aws_codecommit_repository" "flask-repository" {
  repository_name = local.codeCommitName
  description     = "Sample repo containg flask app"
}
