terraform {
  backend "s3" {
    bucket = "terraform-final-project"
    key = "dev/terraform.tfstate"
    region = "us-east-2"
  }
}