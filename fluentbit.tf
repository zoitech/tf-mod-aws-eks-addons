resource "helm_release" "fluent_bit" {
  count = var.enable_fluentbit ? 1 : 0
  
  name             = "aws-for-fluent-bit"
  chart            = "aws-for-fluent-bit"
  namespace        = "kube-system"
  create_namespace = true
  lint             = false
  wait             = false
  force_update     = true
  cleanup_on_fail  = true
  repository       = "https://aws.github.io/eks-charts"

  values = [<<EOF
cloudWatch:
  enabled: true
  match: "*"
  region: "${var.region}"
  logGroupName: "/aws/eks/fluentbit-cloudwatch/${var.cluster_name}"

firehose:
  enabled: false

kinesis:
  enabled: false

elasticsearch:
  enabled: false
EOF
  ]
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  count      = var.enable_fluentbit ? 1 : 0
  
  role       = var.node_group_role_name 
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
