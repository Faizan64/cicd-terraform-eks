terraform {
  backend "s3" {
    bucket = "mytodoappbuckett"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-2"
  }
}