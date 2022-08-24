variable "alarm_name" {
  description = "The human readable name of the alarm"
  type        = string
  validation {
    condition     = can(regex("^[0-9a-zA-Z-]+$", var.alarm_name))
    error_message = "Characters in alarm_name must be separated with hyphens ('-')."
  }
}

variable "alarm_rule" {
  type        = string
  description = "An expression that specifies which other alarms are to be evaluated."
}

variable "alarm_description" {
  description = "The human readable description of the alarm"
  type        = string
}

variable "tags" {
  description = "Resource names based on stage and terraform-true already included"
  type        = map(string)
  default     = {}
}


variable "stage" {
  type        = string
  default     = "dev"
  description = "The stage to deploy: dev, qa, uat, or prod"

  validation {
    condition     = can(regex("dev|qa|uat|prod", var.stage))
    error_message = "The stage value must be a valid stage: dev, qa, uat, or prod."
  }
}

variable "service" {
  type        = string
  default     = "global"
  description = "The service the resource belongs to: notification, personalize, analytics, or global."

  validation {
    condition     = can(regex("notification|personalize|analytics|global", var.service))
    error_message = "The service value must be a valid service: notification, personalize, analytics, or global."
  }
}

variable "alarm_priority" {
  type        = string
  description = "The priority level of the alarm: low, medium or high."

  validation {
    condition     = can(regex("low|medium|high", var.alarm_priority))
    error_message = "The alarm_priority value must be a valid level: low, medium or high."
  }
}
