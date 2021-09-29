variable "region" {
    default = "eu-central-1"
    description = "AWS region"
}
variable "env" {
  description = "Type of environment, e.g prod, stage"
}

variable "cluster_name"{
    description = "Name of EKS cluster, required if Fluenbit is enabled"
}

#enable addons
variable "enable_fluentbit" {
    description = "enable CloudWatch logging for EKS cluster using fluentbit."
    default = false
}

variable "enable_eks_autoscaler" {
    description = "enable EKS autoscaler"
    default = false
}

#Fluentbit
variable "node_group_role_name" {
  description = "IAM role name of EKS Node Group"
  type = string
  default = ""
}

#AutoScaler
variable "autoscaler_iam_role_arn" {
  description = "IAM Role arn of autoscaler role."
}

#NGINX
variable "nginx_controllers" {
    description = "Creates nginx ingress controllers"
    type = map(object({
      name                     = string
      namespace                = string
      version                  = string
      set_values               = map(string)
    }))
}

variable "lb_backend_protocol" {
  description = "AWS Load Balancer backend protocol"
  default = "http"
}

variable "lb_ssl_ports" {
  description = "AWS Load balancer SSL ports"
  default = "443"
}

variable "lb_connection_idle_timeout" {
  description = "AWS Load Balancer connection idle timeout"
  default = "120"
}

#tags
variable "tags" {
  description = "AWS Resource tags"
}
