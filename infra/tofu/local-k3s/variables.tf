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

variable "cluster_specific" {
  default  = {}
  nullable = false
  type = object({
    cilium_devices = optional(list(string), [])
  })
}

variable "git_source" {
  nullable = false
  type = object({
    branch     = optional(string, "main")
    repository = string
  })
}
