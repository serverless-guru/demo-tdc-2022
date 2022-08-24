variable "name" {
  description = "The name to use for the repocitory"
  type        = string
}

variable "region" {
  description = "The name of author"
  type        = string
  default     = "us-east-2"
}

variable "created_by" {
  type = string
}

variable "tags" {
  type        = map(string)
  description = "Key/Value pairs of tags"
  default     = {}
}

variable "stage" {
  type        = string
  default     = "sandbox"
  description = "The stage to deploy: sandbox, dev, qa, uat, or prod"

  validation {
    condition     = can(regex("sandbox|dev|qa|uat|prod", var.stage))
    error_message = "The stage value must be a valid stage: sandbox, dev, qa, uat, or prod."
  }
}