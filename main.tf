data "aws_availability_zones" "available" {}

# You cannot create a new backend by simply defining this and then
# immediately proceeding to "terraform apply". The S3 backend must
# be bootstrapped according to the simple yet essential procedure in
# https://github.com/cloudposse/terraform-aws-tfstate-backend#usage
module "terraform_state_backend" {
  source = "cloudposse/tfstate-backend/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.35.1"
  namespace = "hl-labs"
  stage = var.env
  name = "remote-state-storage"

  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  force_destroy = false
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.cidr
  azs = data.aws_availability_zones.available.names
  private_subnets = [
    cidrsubnet(var.cidr, 8, 1),
    cidrsubnet(var.cidr, 8, 2),
    cidrsubnet(var.cidr, 8, 3)]
  public_subnets = [
    cidrsubnet(var.cidr, 8, 4),
    cidrsubnet(var.cidr, 8, 5),
    cidrsubnet(var.cidr, 8, 6)]
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames = true
  enable_dns_support = true

  enable_dhcp_options = true
  //  dhcp_options_domain_name   = "service.consul"
  manage_default_route_table = true
  default_route_table_tags = {
    DefaultRouteTable = true
  }

  # Cloudwatch log group and IAM role will be created
  enable_flow_log = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role = true
  flow_log_max_aggregation_interval = 60

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  subnets = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id
  enable_irsa               = true

  worker_groups = [
    {
      name = "on-demand-1"
      root_encrypted = true
      capacity_type = "ON_DEMAND"
      instance_type = var.on_demand_instance_type
      root_volume_size = var.on_demand_root_volume_size
      asg_max_size = var.on_demand_asg_max_size
      kubelet_extra_args = "--node-labels=node.kubernetes.io/lifecycle=normal"
      suspended_processes = [
        "AZRebalance"]
    },
    {
      name = "spot-1"
      root_encrypted = true
      capacity_type = "SPOT"
      spot_price = var.spot_price
      instance_type = var.spot_instance_type
      root_volume_size = var.spot_root_volume_size
      asg_max_size = var.spot_asg_max_size
      kubelet_extra_args = "--node-labels=node.kubernetes.io/lifecycle=spot"
      suspended_processes = [
        "AZRebalance"]
      tags = [
        {
          key = "k8s.io/cluster-autoscaler/enabled"
          propagate_at_launch = "false"
          value = "true"
        },
        {
          key = "k8s.io/cluster-autoscaler/${var.cluster_name}"
          propagate_at_launch = "false"
          value = "true"
        }
      ]
    }
  ]
}

resource "null_resource" "kube_config" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name} --no-verify-ssl"
  }
  depends_on = [
    module.eks
  ]
}

//resource "null_resource" "install_calico_plugin" {
//  provisioner "local-exec" {
//    command = "/bin/bash ./scripts/scripts.sh"
//  }
//  depends_on = [
//    module.eks, null_resource.kube_config
//  ]
//}
