locals {
  tags = merge(var.tags,
    {
      Terraform = true
      Service   = "ecs-tf"
      Stage     = var.stage
      CreatedBy = var.created_by
  })
}

variable "ecs_tf_image_tag" {
  type = string
}

variable "region" {
  default = "us-east-2"
}

variable "kms_key_alias_id" {
  type = string
}

variable "views_db_name" {
  type = string
}

variable "service" {
  type        = string
  default     = "ecs-tf"
  description = "service to match what serverless framework deploys"
}

variable "stage" {
  type        = string
  default     = "dev"
  description = "The stage to deploy: local, dev, qa, uat, or prod"

  validation {
    condition     = can(regex("local|dev|qa|uat|prod", var.stage))
    error_message = "The stage value must be a valid stage: local, dev, qa, uat, or prod."
  }
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
