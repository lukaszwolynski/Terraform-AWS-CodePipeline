@echo off
terraform init
terraform apply -target aws_codecommit_repository.flask-repository -auto-approve
cd MyFlaskRepository
git init
git add .
git commit -m "Initial commit"
::If you changed default region and repository name in variables.tf file, you need to change it as well
git remote add origin https://git-codecommit.eu-central-1.amazonaws.com/v1/repos/MyFlaskRepository
git push origin master
timeout 5
cd .. 
terraform apply -auto-approve

echo "Your infrastracture is ready :)"
timeout 10