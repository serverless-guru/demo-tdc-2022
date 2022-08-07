resource "aws_api_gateway_resource" "api" {
  parent_id   = var.parent_id
  path_part   = var.path_name
  rest_api_id = var.api_gw_id
}
