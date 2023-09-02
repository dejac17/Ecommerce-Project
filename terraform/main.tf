terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure Provider
provider "aws" {
  region = "us-west-1"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "main"
  output_path = "main.zip"
}

# Lambda function
resource "aws_lambda_function" "test_lambda" {
  filename      = "main.zip"
  function_name = "Handler"
  role          = aws_iam_role.for_lambda.arn
  handler       = "main"
  runtime = "go1.x"
}

# Gives lambda permission to write to cloudwatch
resource "aws_lambda_permission" "allow-cloudwatch" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_log_group.hello-world.arn}/*/*"
}
# Defines Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "hello-world" {
  name = "${aws_lambda_function.test_lambda.function_name}"
  retention_in_days = 30
}

