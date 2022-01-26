resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = "${file("iam/lambda-assume.json")}"
}

###
resource "aws_api_gateway_rest_api" "api" {
  name = var.rest_api
}

resource "aws_api_gateway_resource" "resource" {
  count = length(var.http_methods)
  path_part   = join("-", [var.resource_name,var.http_methods[count.index]])
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}


resource "aws_api_gateway_method" "method" {
  count = length(var.http_methods)
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource[count.index].id
  http_method   = var.http_methods[count.index]
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "integration" {
  count = length(var.http_methods)
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource[count.index].id
  http_method             = aws_api_gateway_method.method[count.index].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.test_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "example" {
   depends_on = [
     aws_api_gateway_integration.integration]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "apiv1"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/*"
}

###
data "archive_file" "prig" {
  type        = "zip"
  source_file = var.code_path 
  output_path = "prog.zip"
}


resource "aws_lambda_function" "test_lambda" {
  filename      = "prog.zip"
  function_name = "prog"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "prog.lambda_handler"

  source_code_hash = filebase64sha256("prog.zip")

  runtime = "python3.9"

}

output "base_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}
