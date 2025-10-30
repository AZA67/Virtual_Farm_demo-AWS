output "function_name" {
  value = aws_lambda_function.backend.function_name
  description = "for use in api gateway permissions to invoke lambda"
}

output "invoke_arn" {
  value = aws_lambda_function.backend.invoke_arn
  description = "used by api gateway as invoke_uri"
}