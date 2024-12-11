terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.67.0"
    }
  }
  backend "s3" {
    bucket = "eks-voting-app-terraform-bucket"
    key = "key/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}