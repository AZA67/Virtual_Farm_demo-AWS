##---API Gateway HTTP---#
resource "aws_apigatewayv2_api" "http_api" {
  name = "${var.project_name}-http_api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_route" "any_api_proxy" {
  api_id = aws_apigatewayv2_api.http_api.id
  route_key = "ANY /api/{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id = aws_apigatewayv2_api.http_api.id
  name = "$default"
  auto_deploy = true
}

##---Integration With Lambda---##
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id = aws_apigatewayv2_api.http_api.id
  integration_method = "POST"
  integration_type = "AWS_PROXY"
  integration_uri = var.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_lambda_permission" "allow_apigw_invoke" {
  statement_id = "AllowInvokeFromHttpApi"
  action = "lambda:InvokeFunction"
  function_name = var.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}