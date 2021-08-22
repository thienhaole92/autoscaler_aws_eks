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

# Configuration block with resource tag settings to apply across all resources handled by this provider
variable "default_tags" {
  type = map
  default = {
    "Owner" = "HaoLe"
    "Environment" = "Lab/Demo/Testing"
    "Managed-By" = "Terraform"
  }
}

variable "k8s_service_account_name" {
  type = string
  default = "cluster-autoscaler-aws-cluster-autoscaler-chart"
}

variable "app" {
  type = string
  default = "eks_demo"
}

# Environment
variable "env" {
  type = string
  default = "dev"
}

# Name to be used on the VPC
variable "vpc_name" {
  type = string
  default = "hl-labs"
}

# The CIDR block for the VPC
variable "cidr" {
  type = string
  default = "172.22.0.0/16"
}

# Name to be used on the cluster
variable "cluster_name" {
  type = string
  default = "hl-labs-eks-cluster"
}

# The Kubernetes server version for the EKS cluster.
variable "cluster_version" {
  type = string
  default = "1.20"
}

# On-Demand Pool
variable "on_demand_instance_type" {
  type = string
  default = "t3.small"
}

variable "on_demand_root_volume_size" {
  type = number
  default = 20
}

variable "on_demand_asg_max_size" {
  type = number
  default = 1
}

# Spot Pool
variable "spot_instance_type" {
  type = string
  default = "t3.small"
}

variable "spot_root_volume_size" {
  type = number
  default = 20
}

variable "spot_asg_max_size" {
  type = number
  default = 5
}

variable "spot_price" {
  type = string
  default = "0.0472"
}

variable "enable_termination_handler" {
  type = bool
  default = true
  # ok
}

variable "enable_autoscaler" {
  type = bool
  default = true
  # ok
}

variable "enable_alb_ingress_controller" {
  type = bool
  default = true
  # ok
}

variable "enable_external_dns" {
  type = bool
  default = false
  # untested
}

variable "enable_certificate_manager" {
  type = bool
  default = false
  # BROKEN
}
