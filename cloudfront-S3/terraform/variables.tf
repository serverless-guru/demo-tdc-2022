variable "domain_name" {
  type        = string
  description = "FQDN of the website"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "eu-central-1"
}
