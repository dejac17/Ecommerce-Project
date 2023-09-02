# Create api
resource "aws_apigatewayv2_api" "http-api" {
  name = "hello-world-api"
  protocol_type = "HTTP"
}

# Stage for api
resource "aws_apigatewayv2_stage" "lambda-testing" {
  api_id = aws_apigatewayv2_api.http-api.id
  name = "lambda-stage"
  auto_deploy = true
}

# Integrate gateway with lambda function
resource "aws_apigatewayv2_integration" "lambda" {
  api_id = aws_apigatewayv2_api.http-api.id
  integration_type = "AWS_PROXY"
  description = "Integration with hello world lambda"
  integration_method = "POST"
  integration_uri = aws_lambda_function.test_lambda.invoke_arn
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "lambda-route" {
  api_id = aws_apigatewayv2_api.http-api.id
  route_key = "GET /{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

# Gives api gateway permission to invoke lambda
 resource "aws_lambda_permission" "api-gw" {
   statement_id = "AllowExecutionFromAPIGateway"
   action = "lambda:InvokeFunction"
   function_name = aws_lambda_function.test_lambda.function_name
   principal = "apigateway.amazonaws.com"
   source_arn = "${aws_apigatewayv2_api.http-api.execution_arn}/*/*"
 }