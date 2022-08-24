variable "alarm_name" {
  description = "The human readable name of the alarm"
  type        = string
  validation {
    condition     = can(regex("^[0-9a-zA-Z-]+$", var.alarm_name))
    error_message = "Characters in alarm_name must be separated with hyphens ('-')."
  }
}

variable "comparison_operator" {
  description = "Comparison Operator to compare with the threshold"
  type        = string
}

variable "namespace" {
  description = "The human readable name of the metric's namespace. Defaults to $service-$stage"
  type        = string
  default     = ""
}

variable "metric_name" {
  description = "Name of the metric"
  type        = string
}

variable "dimensions" {
  description = "The dimensions for the alarm's associated metric."
  type        = map(string)
  default     = {}
}

variable "alarm_description" {
  description = "The human readable description of the alarm"
  type        = string
}

variable "alarm_actions" {
  description = "The list of actions to execute the state transitions into ALARM."
  type        = list(string)
  default     = []
}

variable "ok_actions" {
  description = "The list of actions to execute the state transitions into OK."
  type        = list(string)
  default     = []
}

variable "evaluation_periods" {
  description = "How many most recent periods should be evaluated to detect a breach"
  type        = number
}

variable "datapoints_to_alarm" {
  description = "is the number of data points within the Evaluation Periods that must be breaching to cause the alarm to go to the ALARM state."
  type        = number
  default     = null
}

variable "period" {
  description = "Duration of the evaluated period in seconds"
  type        = number
}

variable "statistic" {
  description = "SUM, AVERAGE, SAMPLE_COUNT, etc"
  type        = string
}

variable "threshold" {
  description = "Threshold for Alarm"
  type        = number
}

variable "treat_missing_data" {
  description = "Alarm should treat missig data as -"
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
  description = "The service that the resource belongs to."

  validation {
    condition     = can(regex("notification|personalize|analytics|global|external-api-cache|hcom|hdp-ingestor|ecs-tf", var.service))
    error_message = "The service value must be a valid service: notification, personalize, analytics, external-api-cache, hcom, hdp-ingestor, ecs-tf or global."
  }
}

variable "alarm_priority" {
  type        = string
  description = "The priority level of the alarm: low, medium, high or critical."

  validation {
    condition     = can(regex("low|medium|high|critical", var.alarm_priority))
    error_message = "The alarm_priority value must be a valid level: low, medium, high or critical."
  }
}

variable "mute" {
  type        = string
  description = "Mutes the alarm by ignoring it in the alarm processor function"
  default     = "no"
  validation {
    condition     = can(regex("yes|no", var.mute))
    error_message = "The mute value must be a valid config: yes or no."
  }
}
