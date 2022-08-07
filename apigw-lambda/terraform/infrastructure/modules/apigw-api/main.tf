resource "aws_api_gateway_rest_api" "api" {
  name = var.name

  tags = local.tags
}

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    # Will always redeploy
    redeployment = sha1(uuid())
  }

  depends_on = [aws_api_gateway_rest_api.api]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = var.stage
}
