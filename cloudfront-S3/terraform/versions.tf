terraform {
  required_version = "1.2.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.25.0"
    }
  }
}

provider "aws" {
  region = var.region
}
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}
