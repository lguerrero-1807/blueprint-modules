variable "endpoint" {
  description = "The endpoint for the EKS cluster"
  type        = string
}

variable "certificate_authority_data" {
  description = "The certificate authority data for the EKS cluster"
  type        = string
}

variable "token" {
  description = "The authentication token for the EKS cluster"
  type        = string
}
