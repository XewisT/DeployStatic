variable "aws_access_id" {
  description = "AWS Access Id"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "root_domain_name" {
  type    = string
  default = "dev-vysh.com"
}
