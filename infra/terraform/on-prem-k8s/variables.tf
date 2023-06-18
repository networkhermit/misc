variable "GITHUB_OWNER" {
  nullable = false
  type     = string
}

variable "KUBE_CLIENT_CERT_DATA" {
  nullable = false
  type     = string
}

variable "KUBE_CLIENT_KEY_DATA" {
  nullable  = false
  sensitive = true
  type      = string
}

variable "KUBE_CLUSTER_CA_CERT_DATA" {
  nullable = false
  type     = string
}

variable "KUBE_HOST" {
  nullable = false
  type     = string
}

variable "github_branch" {
  default  = "main"
  nullable = false
  type     = string
}

variable "github_repository" {
  nullable = false
  type     = string
}
