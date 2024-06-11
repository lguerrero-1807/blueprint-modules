provider "helm" {
  kubernetes {
    host                   = var.endpoint
    cluster_ca_certificate = base64decode(var.certificate_authority_data)
    token                  = var.token
  }
}