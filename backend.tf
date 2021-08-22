terraform {
  required_version = ">= 0.12.2"

  backend "s3" {
    region         = "ap-southeast-1"
    bucket         = "hl-labs-dev-remote-state-storage"
    key            = "terraform.tfstate"
    dynamodb_table = "hl-labs-dev-remote-state-storage-lock"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
