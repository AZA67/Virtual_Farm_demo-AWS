resource "aws_s3_bucket" "s3b" {
    bucket = "${var.project_name}-s3b"
    force_destroy = true

    tags = {
        name = "${var.project_name}-s3b"
    }
}

resource "aws_s3_bucket_ownership_controls" "s3b-object_ownership" {
    bucket = aws_s3_bucket.s3b.id 
    rule {
        object_ownership = "BucketOwnerEnforced"
    }
}

resource "aws_s3_bucket_versioning" "s3b-versioning" {
    bucket = aws_s3_bucket.s3b.id
    versioning_configuration {
      status = "Enabled"
    }
}