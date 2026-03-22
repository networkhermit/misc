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

variable "registry_mirror" {
  nullable = true
  type = object({
    host     = string
    username = string
  })
}

variable "registry_mirror_sensitive" {
  nullable  = true
  sensitive = true
  type = object({
    password = string
  })
}

variable "state_backend_s3_bucket" {
  type = string
}

variable "state_backend_s3_key" {
  type = string
}

variable "state_encryption_passphrase" {
  sensitive = true
  type      = string
}
