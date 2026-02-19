terraform {
  backend "s3" {
    bucket = "terraform-final-project"
    key = "prod/terraform.tfstate"
    region = "us-east-2"
  }
}