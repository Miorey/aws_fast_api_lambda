
resource "aws_iam_role" "my_fast_api_role" {
  name = "my-fast-api-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.my_fast_api_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "my_fast_api"{
  depends_on = [aws_apigatewayv2_stage.lambda]
  filename = "${var.archive_root}/my-fast-api.zip"
  function_name = "my-fast-api"
  description   = "My fast api lambda"
  handler       = "main.handler"
  runtime       = "python3.8"
  source_code_hash = filebase64sha256("${var.archive_root}/my-fast-api.zip")
  role                   = aws_iam_role.my_fast_api_role.arn
}

resource "aws_apigatewayv2_api" "lambda" {
  name          = "fast_api_lambda_gw"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins     = split(",", var.allowed_hosts)
    allow_headers     = ["*"]
    allow_methods     = ["GET", "POST", "DELETE", "PUT", "PATCH", "OPTIONS"]
  }
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id
  name        = "$default"
  auto_deploy = true
  lifecycle {
    ignore_changes = [deployment_id, default_route_settings]
  }
}

resource "aws_apigatewayv2_integration" "my_fast_api" {
  api_id = aws_apigatewayv2_api.lambda.id
  integration_type   = "AWS_PROXY"
  description        = "Lambda example"
  integration_uri    = aws_lambda_function.my_fast_api.invoke_arn
  passthrough_behavior = "WHEN_NO_MATCH"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "my_fast_api" {
  api_id = aws_apigatewayv2_api.lambda.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.my_fast_api.id}"
}

resource "aws_cloudwatch_log_group" "fast_api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"
  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_fast_api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*"
}
