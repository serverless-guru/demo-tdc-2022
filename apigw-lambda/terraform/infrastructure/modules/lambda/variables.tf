locals {
  tags = merge(var.tags,
    {
      Terraform = true
      Service   = "apigw-lambda-app"
      CreatedBy = var.created_by
  })

  name = "${var.service}-${var.func_name}"
}

variable "region" {
  default = "ap-south-1"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "service" {
  type        = string
  default     = "apigw-lambda-app"
  description = "service to match what serverless framework deploys"
}

variable "func_name" {
  type        = string
  description = "Name of the function"
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