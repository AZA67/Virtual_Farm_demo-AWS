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
data "archive_file" "lambda_handler" {
  type        = "zip"
  source_file = "${var.lambda_dir}/handler.py"
  output_path = "${var.lambda_dir}/function.zip"
}

# Lambda function
resource "aws_lambda_function" "backend" {
  filename         = "${var.lambda_dir}/function.zip" 
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
    name = "${var.project_name}"
  }
}