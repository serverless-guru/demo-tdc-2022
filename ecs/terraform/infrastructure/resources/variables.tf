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

variable "ecs_tf_image_tag" {
  type = string
}

variable "service" {
  type        = string
  default     = "apigw-lambda-tf-app"
  description = "service to match what serverless framework deploys"
}

variable "created_by" {
  description = "Company or vendor name followed by the username part of the email address - like serverlessguru-yann"
  default     = "serverlessguru-tushar-sharma"
}

variable "tags" {
  type        = map(string)
  description = "Key/Value pairs of default tags"
  default = {
    appFor = "tdc-demo",
  }
}
