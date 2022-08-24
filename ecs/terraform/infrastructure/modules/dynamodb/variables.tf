variable "db_name" {
  description = "The name to use for the db"
  type        = string
}

variable "pk_name" {
  description = "The name to use for the PK"
  type        = string
  default     = "PK"
}

variable "sk_name" {
  description = "The name to use for the SK"
  type        = string
  default     = "SK"
}

variable "ttl" {
  description = "Enables TTL"
  type        = bool
  default     = false
}

variable "stream_enabled" {
  description = "Enables DynamoDB Streams"
  type        = bool
  default     = false
}

variable "created_by" {
  description = "The name of author"
  type        = string
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

variable "global_secondary_indexes" {
  type        = any
  description = "List of the Hash Keys and Range key for GSIs"
  default     = []
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key for Table encryption"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Key/Value pairs of tags"
  default     = {}
}
