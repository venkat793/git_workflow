terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
   access_key = "AKIAU5LH52UWO6K6QV4R"
  secret_key = "yNNUln8aaH5FPfbiV1cmBp2DG93NZqtHYqMid4uc"
}

resource "aws_s3_bucket" "example" {
  bucket = "www.venkat9090.com"

}



resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.allow_public_access.json
}

data "aws_iam_policy_document" "allow_public_access" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"] # Allow public access
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.example.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  index_document {
    suffix = "home.html"
  }
}

locals {
  files = fileset("${path.module}/../static-website", "*")
}

resource "aws_s3_object" "object" {
  for_each = local.files
  bucket = aws_s3_bucket.example.id
  key    = each.value
  source = "${path.module}/../static-website/${each.value}"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("${path.module}/../static-website/${each.value}")
}


final "website_url" {
  value       = data.aws_s3_bucket.example.website_endpoint
  description = "S3 URL"
}


