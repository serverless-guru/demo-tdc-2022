terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.1"
  backend "s3" {
    bucket         = "tushar-sharma-slsguru-tdc-demo-terraform-backend"
    key            = "apigw-lambda-app.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tushar-sharma-slsguru-tdc-demo-terraform-backend-lock"
  }
}

provider "aws" {
  region = "ap-south-1"
}
