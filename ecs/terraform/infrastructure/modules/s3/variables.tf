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

variable "created_by" {
  type = string
}

variable "tags" {
  type        = map(string)
  description = "Key/Value pairs of tags"
  default     = {}
}

variable "expire" {
  type        = number
  description = "Days before content expiry (-1 to disable)"
  default     = -1
}

variable "acl" {
  type        = string
  description = "Bucket ACL (private, public-read, public-read-write, aws-exec-read, authenticated-read, log-delivery-write)"
  default     = "private"

  validation {
    condition     = can(regex("private|public-read|public-read-write|aws-exec-read|authenticated-read|log-delivery-write", var.acl))
    error_message = "The ACL must be a vaid value: private, public-read, public-read-write, aws-exec-read, authenticated-read, log-delivery-write."
  }
}
