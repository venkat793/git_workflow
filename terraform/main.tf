

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.71.0"
    }
  }
}


provider "aws" {
  region = "eu-north-1"
}

# S3 Bucket Creation
resource "aws_s3_bucket" "my_bucket_1306" {
  bucket = "test-1306"
}



# Server-Side Encryption for S3 Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.my_bucket_1306.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.my_bucket_1306.id

  versioning_configuration {
    status = "Enabled"
  }

}
