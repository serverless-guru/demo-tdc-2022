locals {
  tags = merge(var.tags,
    {
      Terraform = true
      Service   = "apigw-lambda-tf-app"
      CreatedBy = var.created_by
  })
}

variable "region" {
  default = "ap-south-1"
}

variable "accountId" {
  type = string
}

variable "resource_id" {
  type = string
}

variable "api_gw_id" {
  type = string
}

variable "http_method" {
  type = string
}

variable "resource_path" {
  type = string
}

variable "lambda_invoke_arn" {
  type = string
}

variable "lambda_func_name" {
  type = string
}

variable "service" {
  type        = string
  default     = "apigw-lambda-tf-app"
  description = "service to match what serverless framework deploys"
}

variable "created_by" {
  description = "Company or vendor name followed by the username part of the email address - like serverlessguru-yann"
  default     = "pipeline"
}

variable "tags" {
  type        = map(string)
  description = "Key/Value pairs of default tags"
  default     = {}
}
