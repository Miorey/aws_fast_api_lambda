# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."
  type    = string
  default = "eu-central-1"
}

variable "allowed_hosts" {
  description = "Separated list of allowed hosts"
  default     = "*"
}

variable "archive_root" {
  type = string
  default = "./../dist"
}

variable "api_name" {
  type = string
  default = "develinside-api"
}