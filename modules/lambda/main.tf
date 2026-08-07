# Minimum constraints only; the environment roots own the actual version pin.
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.0"
    }
  }
}

# Paths come from the caller: path.module here would resolve to modules/lambda, not the repo root.
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = var.source_file
  output_path = var.build_output_path
}

resource "aws_lambda_function" "api" {
  function_name = var.function_name
  role          = var.role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  # null leaves concurrency unreserved.
  reserved_concurrent_executions = var.reserved_concurrent_executions

  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}
