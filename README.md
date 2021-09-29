# tf-mod-aws-eks-addons

## Autoscaler

### Pre-requisites
**1. Create an OIDC provider** that Autoscaler will use. 

You can use the output from the EKS module (if cluster was created with the module) named oidc_provider_issuer; e.g url `module.eks.oidc_provider_issuer`

**2. IAM Role and IAM Policy**

Create the IAM Role & IAM Policy and pass it in to the module.

Please remember that when creating the IAM Role, the sts Assume Role policy service account name should be cluster-autoscaler.

Please see further documention here:
- [GitHub Helm AWS Autscaler](https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler#aws---using-auto-discovery-of-tagged-instance-groups)
- [GitHub Helm Example](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/CA_with_AWS_IAM_OIDC.md)
- [AWS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html)

## NGINX Ingress Controller

### Pre-requisites
Allow capability: NET_BIND_SERVICE

### Variable Configuration

| Parameter | Description | Type of value
| - | - | - 
| `name`| name of nginx ingress controller | string
| `namespace`| namespace into which the controller will be deployed | string
| `version`| Version of Nginx Ingress Controller chart | string
| `set_values`| This is to set the values for additional configuration as opposed to passing them in, we can just name the value we want to change and set that value. | map(string)
| ``|  |  |


Example usage:
```hcl
nginx_controllers = {
    nginx_public = {
      name                     = "nginx-public"
      namespace                = "c-ingress-controller"
      version                  = "0.3.5"
      set_values               =  {
        controller.service.targetPorts.https = "http"
        controller.service.targetPorts.enableHttp = "false"
        controller.service.annotations.service.beta.kubernetes.io/aws-load-balancer-backend-protocol = "http"
      }
    },
    nginx_internal = {
      name                     = "nginx-internal"
      namespace                = "i-ingress-controller"
      version                  = "0.3.5"
      set_values               = {
        controller.service.targetPorts.https = "http"
        controller.service.targetPorts.enableHttp = "false"
        controller.service.annotations.service.beta.kubernetes.io/aws-load-balancer-backend-protocol = "http"
      }
    }
}
```

## Fluentbit
Fluentbit automatically creates a CloudWatch log group with the following naming convention: 
- logGroupName: "/aws/eks/fluentbit-cloudwatch/${var.cluster_name}"

### Example usage of Module
```hcl
module "eks_add_ons" {
  source = "git::https://"
  
  region = "eu-central-1"
  cluster_name = local.cluster_name

  enable_fluentbit = false
  enable_eks_autoscaler = true

  autoscaler_iam_role_arn = aws_iam_role.autoscaler.arn
  
  nginx_controllers = {
    public = {
      name = "public"
      namespace = "c-ingress"
      version = ""
      set_values               = {
        controller.service.targetPorts.https = "http"
        controller.service.targetPorts.enableHttp = "false"
        controller.service.annotations.service.beta.kubernetes.io/aws-load-balancer-backend-protocol = "http"
      }
    }
  }

  node_group_role_name = aws_iam_role.eks_node_group.name

  tags = {
    test = "test.user@test.com"
    env = "test"
    app = "test1234"
  }
}
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy_attachment.CloudWatchAgentServerPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.fluent_bit](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaler_iam_role_arn"></a> [autoscaler\_iam\_role\_arn](#input\_autoscaler\_iam\_role\_arn) | IAM Role arn of autoscaler role. | `any` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of EKS cluster, required if Fluenbit is enabled | `any` | n/a | yes |
| <a name="input_enable_eks_autoscaler"></a> [enable\_eks\_autoscaler](#input\_enable\_eks\_autoscaler) | enable EKS autoscaler | `bool` | `false` | no |
| <a name="input_enable_fluentbit"></a> [enable\_fluentbit](#input\_enable\_fluentbit) | enable CloudWatch logging for EKS cluster using fluentbit. | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | Type of environment, e.g prod, stage | `any` | n/a | yes |
| <a name="input_lb_backend_protocol"></a> [lb\_backend\_protocol](#input\_lb\_backend\_protocol) | AWS Load Balancer backend protocol | `string` | `"http"` | no |
| <a name="input_lb_connection_idle_timeout"></a> [lb\_connection\_idle\_timeout](#input\_lb\_connection\_idle\_timeout) | AWS Load Balancer connection idle timeout | `string` | `"120"` | no |
| <a name="input_lb_ssl_ports"></a> [lb\_ssl\_ports](#input\_lb\_ssl\_ports) | AWS Load balancer SSL ports | `string` | `"443"` | no |
| <a name="input_nginx_controllers"></a> [nginx\_controllers](#input\_nginx\_controllers) | Creates nginx ingress controllers | <pre>map(object({<br>      name                     = string<br>      namespace                = string<br>      version                  = string<br>      set_values               = map(string)<br>    }))</pre> | n/a | yes |
| <a name="input_node_group_role_name"></a> [node\_group\_role\_name](#input\_node\_group\_role\_name) | IAM role name of EKS Node Group | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"eu-central-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS Resource tags | `any` | n/a | yes |

## Outputs

No outputs.
