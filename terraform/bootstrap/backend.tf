terraform {
### UNCOMMENT vvv AND RE_INIT TO ADD REMOTE ###
#    backend "s3" {
#      bucket = "tf-states"
#      key = "terraform.tfstate"
#      region = "us-east-2"
#      dynamodb_table = "tf-state-lock"
#      encrypt = true 
#    }
#---------------------------------------------#    
    required_version = ">=1.13"
    required_providers {
     aws = {
        source = "hashicorp/aws"
        version = ">6.0"
     }
   }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "tf-states"
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
  bucket = aws_s3_bucket.tf_state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "tf_state_lock" {
  name = "tf-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}