terraform {    
    required_version = ">=1.13"
    required_providers {
     aws = {
        source = "hashicorp/aws"
        version = ">6.0"
     }
   }
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_s3_bucket" "tf_state_bucket" {
  bucket = "${var.project_name}-tf-state"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
  bucket = aws_s3_bucket.tf_state_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "tf_state_lock" {
  name = "${var.project_name}-tf_state_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}