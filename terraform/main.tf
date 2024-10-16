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


resource "aws_s3_bucket" "bucket899899" {
  bucket = "bucket899899"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
