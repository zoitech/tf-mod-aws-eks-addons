resource "helm_release" "cert_manager" {
  count = var.enable_cert_manager ? 1 : 0
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.cert_manager_version
  namespace        = "infra"
  create_namespace = true

  set {
    name  = "controller.replicaCount"
    value = var.cert_manager_replicaCount
  }

  set {
    name = "installCRDs"
    value = true
  }
}
