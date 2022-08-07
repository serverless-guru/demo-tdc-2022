output "resource_id" {
  value       = aws_api_gateway_resource.api.id
  description = "The resource id of the path part"
}

output "resource_path" {
  value       = aws_api_gateway_resource.api.path
  description = "The resource path of the resource"
}
