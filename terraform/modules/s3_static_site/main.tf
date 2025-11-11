
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

resource "aws_s3_bucket_server_side_encryption_configuration" "s3b_sse" {
  bucket = aws_s3_bucket.s3b.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

##--static site objects (hmtl/css/js)--##


resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.s3b.id
  key = "index.html"
  source = "${var.s3_assets_dir}/index.html"
  etag = filemd5("${var.s3_assets_dir}/index.html") #used for terraform to track local changes in state#
  server_side_encryption = "AES256"
  
  content_type = "text/html; charset=utf-8"
}

resource "aws_s3_object" "styles_css" {
  bucket = aws_s3_bucket.s3b.id
  key = "styles.css"
  source = "${var.s3_assets_dir}/styles.css"
  etag = filemd5("${var.s3_assets_dir}/styles.css")
  server_side_encryption = "AES256"

  content_type = "text/css; charset=utf-8"
}

resource "aws_s3_object" "app_js" {
  bucket = aws_s3_bucket.s3b.id
  key = "app.js"
  source = "${var.s3_assets_dir}/app.js"
  etag = filemd5("${var.s3_assets_dir}/app.js")
  server_side_encryption = "AES256"

  content_type = "application/javascript"
}