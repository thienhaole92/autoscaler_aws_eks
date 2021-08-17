# AWS credentials or configuration file to specify your credentials.
variable "credentials_file" {
  type = string
  default = "demo"
}

# AWS profile name as set in the shared credentials file
variable "aws_profile" {
  type = string
  default = "default"
}

# AWS region
variable "aws_region" {
  type = string
  default = "ap-southeast-1"
}

variable "default_tags" {
  type = map
  default = {
    "Owner" = "HaoLe"
    "Environment" = "Lab/Demo/Testing"
    "Managed-By" = "Terraform"
  }
}

variable "vpc_name" {
  type = string
  default = "hl-labs"
}

variable "cidr" {
  type = string
  default = "172.22.0.0/16"
}
