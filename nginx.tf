resource "helm_release" "nginx" {
  for_each = var.nginx_controllers
  
  name             = each.value.name
  chart            = "ingress-nginx"
  namespace        = each.value.namespace
  version          = each.value.version
  create_namespace = true
  lint             = false
  wait             = false
  cleanup_on_fail  = true
  repository       = "https://kubernetes.github.io/ingress-nginx"
  
  dynamic "set" {
    for_each = each.value.set_values
    content {
      name  = set.key
      value = set.value 
    }
  }
 
  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    value = var.lb_backend_protocol
  }

  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"
    value = var.lb_ssl_ports
  }

  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-connection-idle-timeout"
    value = var.lb_connection_idle_timeout
  }

  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-additional-resource-tags"
    value = replace(replace(replace(replace(jsonencode(var.tags), "\"", ""), ":", "="), "{", ""), "}", "")
  }
}

