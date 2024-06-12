resource "kubernetes_persistent_volume_claim" "prometheus" {
  metadata {
    name      = "prometheus-pvc"
    namespace = "monitoring"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  namespace        = "monitoring"
  create_namespace = true

  set {
    name  = "server.persistentVolume.existingClaim"
    value = kubernetes_persistent_volume_claim.prometheus.metadata[0].name
  }
}