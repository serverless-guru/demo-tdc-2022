resource "aws_api_gateway_method" "api" {
  authorization = "NONE"
  http_method   = var.http_method
  resource_id   = var.resource_id
  rest_api_id   = var.api_gw_id
}

resource "aws_api_gateway_integration" "api" {
  http_method             = var.http_method
  resource_id             = var.resource_id
  rest_api_id             = var.api_gw_id
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_func_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.accountId}:${var.api_gw_id}/*/${aws_api_gateway_method.api.http_method}${var.resource_path}"
}
