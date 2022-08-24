variable "stage" {
  type        = string
  default     = "sandbox"
  description = "The stage to deploy: sandbox, dev, qa, uat, or prod"

  validation {
    condition     = can(regex("sandbox|dev|qa|uat|prod", var.stage))
    error_message = "The stage value must be a valid stage: sandbox, dev, qa, uat, or prod."
  }
}

variable "name" {
  type = string
}



variable "tags" {
  type        = map(string)
  description = "Key/Value pairs of tags"
  default     = {}
}
