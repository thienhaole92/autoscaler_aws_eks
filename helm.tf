resource "helm_release" "aws_node_termination_handler" {
  count = var.enable_termination_handler ? 1 : 0
  depends_on = [
    module.eks,
    null_resource.kube_config
  ]

  name = "aws-node-termination-handler"
  namespace = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart = "aws-node-termination-handler"

  set {
    name = "awsRegion"
    value = var.aws_region
  }
  set {
    name = "enableSpotInterruptionDraining"
    value = "true"
  }
  set {
    name = "enableRebalanceMonitoring"
    value = "true"
  }
  set {
    name = "enableScheduledEventDraining"
    value = "true"
  }
  set {
    name = "logLevel"
    value = "debug"
  }
}

resource "helm_release" "autoscaler" {
  count = var.enable_autoscaler ? 1 : 0
  depends_on = [
    module.eks,
    null_resource.kube_config
  ]

  name = "cluster-autoscaler"
  namespace = "kube-system"
  repository = "https://kubernetes.github.io/autoscaler"
  chart = "cluster-autoscaler"

  values = [
    templatefile(
    "${path.module}/templates/cluster-autoscaler-chart-values.yaml.tpl",
    {
      region = var.aws_region,
      svc_account = var.k8s_service_account_name,
      cluster_name = var.cluster_name,
      role_arn = module.iam_assumable_role_admin.iam_role_arn
    }
    )
  ]

}
