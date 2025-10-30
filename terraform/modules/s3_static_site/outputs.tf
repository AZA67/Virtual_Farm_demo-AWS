output "bucket_name" {
    value = aws_s3_bucket.s3b.bucket
    description = "name of s3 static site bucket {project_name}{bucket_name}"
}

output "bucket_regional_domain_name" {
    value = aws_s3_bucket.s3b.bucket_regional_domain_name
    description = "regional domain for s3-bucket. used for 'cloudfron origin' "
}

output "bucket_arn" {
    value = aws_s3_bucket.s3b.arn
    description = "arn of bucket used in the OAC policy for cloudfront config"
}