resource "aws_lambda_function" "get" {
  function_name = "GoLambdaGetRequests"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = "go-api-lambda"
  s3_key    = "go-api-get.zip"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler     = "main"
  runtime     = "go1.x"
  memory_size = 128
  timeout     = 10

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_example_lambda"

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

resource "aws_api_gateway_rest_api" "go" {
  name = "go_api"
}

resource "aws_api_gateway_resource" "hello" {
  path_part   = "hello"
  parent_id   = aws_api_gateway_rest_api.go.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.go.id
}

resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.go.id
  resource_id   = aws_api_gateway_resource.hello.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.go.id
  resource_id             = aws_api_gateway_resource.hello.id
  http_method             = aws_api_gateway_method.get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.go.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "go_api_deploy" {
  depends_on = [aws_api_gateway_integration.integration]

  rest_api_id = aws_api_gateway_rest_api.go.id
  stage_name  = "v1"

}

output "url" {
  value = "${aws_api_gateway_deployment.go_api_deploy.invoke_url}${aws_api_gateway_resource.hello.path}"
}