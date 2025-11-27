terraform {
  required_version = ">= 1.2"
  backend "s3" {
    bucket         = "myorg-terraform-state"
    key            = "ecommerce/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

