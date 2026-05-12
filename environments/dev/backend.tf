terraform {
  backend "s3" {
    bucket = "terraform-final-project-use1"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}