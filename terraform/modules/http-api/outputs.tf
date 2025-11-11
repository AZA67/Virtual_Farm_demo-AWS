output "http_api_id" {
  value = aws_apigatewayv2_api.http_api.id
  description = "used for id portion of domain name in cloudfront reference"
}