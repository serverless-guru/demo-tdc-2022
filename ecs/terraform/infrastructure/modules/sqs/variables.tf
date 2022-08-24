variable "name" {
  description = "The name to use for the queue"
  type        = string
}

variable "created_by" {
  description = "The name of author"
  type        = string
}

variable "region" {
  description = "The name of author"
  type        = string
  default     = "us-east-2"
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

variable "deadLetterTargetArn" {
  type        = string
  description = "ARN of DLQ for redrive policy"
  default     = ""
}

variable "maxReceiveCount" {
  type        = number
  description = "max Receive Count before sending to DQL (needs deadlettertargetArn defined)"
  default     = 1
}
variable "visibilityTimeout" {
  type        = number
  description = "Visibility Timeout in seconds. Needs to be bigger than attached Lambda timeouts"
  default     = null
}

variable "kms_master_key_id" {
  description = "ID of the KMS Key"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Key/Value pairs of tags"
  default     = {}
}
