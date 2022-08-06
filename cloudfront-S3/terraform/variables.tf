variable "domain_name" {
  type        = string
  description = "FQDN of the website"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "eu-central-1"
}

variable "created_by" {
  type        = string
  description = "Company or vendor name followed by the username part of the email address - like serverlessguru-yann"
  default     = "serverlessguru-daniel-muller"
}

variable "tags" {
  type        = map(string)
  description = "Key/Value pairs of default tags"
  default = {
    app_for = "tdc-demo",
  }
}
