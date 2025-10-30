output "domain_name" {
  description = "Cloudfront domain for testing"
  value = aws_cloudfront_distribution.cdn.domain_name
}