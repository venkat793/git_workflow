terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "< 5.71.0"
    }
  }
}


provider "aws" {
  region = "eu-north-1"
}


terraform {
  backend "s3" {
    bucket         = "statebucket777"
    key            = "terraform/state.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "table7889"
    encrypt        = true
  }
}
