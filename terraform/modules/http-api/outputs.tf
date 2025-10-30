output "http_api_endpoint" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
  description = "used as domain name for orgin in cloudfront distribution"
}