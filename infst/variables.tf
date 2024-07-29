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
  default = "eu-central-1"
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "root_domain_name" {
  type    = string
  default = "dev-vysh.com"
}
