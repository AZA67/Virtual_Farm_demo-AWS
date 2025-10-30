# IAM config
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_exec" {
    name = "${var.project_name}-lambda_execution_role"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

## - Package the Lambda function code (do later)
#data "archive_file" "example" {
#  type        = "zip"
#  source_file = "${path.module}/lambda/index.js"
#  output_path = "${path.module}/lambda/function.zip"
#}

# Lambda function
resource "aws_lambda_function" "backend" {
  filename         = "../../../priv-resources/function.zip" #[ADD AFTER CONFIGURATION OF THIS BLOCK]data.archive_file.example.output_path
  function_name    = "${var.project_name}-lambda_function"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "handler.handler" #[module.function_name(referenced in handler.py)]
  
  runtime = "python3.12"

  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }

  tags = {
    name = "${var.project_name}-table"
  }
}