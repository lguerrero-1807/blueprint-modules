resource "aws_ebs_volume" "prometheus" {
  availability_zone = "us-east-1a"
  size              = 10
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  version          = "45.7.1"
  create_namespace = true

  set {
    name  = "server.persistentVolume.enabled"
    value = "false"
  }

  set {
    name  = "alertmanager.persistentVolume.enabled"
    value = "false"
  }

  set {
    name  = "pushgateway.persistentVolume.enabled"
    value = "false"
  }
}