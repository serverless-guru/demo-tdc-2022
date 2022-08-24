variable "stage" {
  type        = string
  default     = "sandbox"
  description = "The stage to deploy: sandbox, dev, qa, uat, or prod"

  validation {
    condition     = can(regex("sandbox|dev|qa|uat|prod", var.stage))
    error_message = "The stage value must be a valid stage: sandbox, dev, qa, uat, or prod."
  }
}

variable "created_by" {
  type = string
}
variable "used_for" {
  type = string
}
variable "name" {
  type        = string
  description = "Name for the alias"
}

variable "tags" {
  type        = map(string)
  description = "Key/Value pairs of tags"
  default     = {}
}
