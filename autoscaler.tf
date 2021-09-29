resource "helm_release" "cluster_autoscaler" {
  count = var.enable_eks_autoscaler ? 1 : 0
  
  chart            = "cluster-autoscaler"
  namespace        = "kube-system"
  create_namespace = false
  name             = "cluster-autoscaler"
  repository       = "https://kubernetes.github.io/autoscaler"

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "rbac.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.autoscaler_iam_role_arn
  }
}


