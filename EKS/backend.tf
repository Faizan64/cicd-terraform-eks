terraform {
  backend "s3" {
    bucket = "mytodoappbuckett"
    key    = "EKS-setup/terraform.tfstate"
    region = "us-east-2"
  }
}