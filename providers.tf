provider "aws" {
  shared_credentials_file = var.credentials_file
  profile                 = var.aws_profile
  region                  = var.aws_region

  default_tags {
    tags = var.default_tags
  }
}
