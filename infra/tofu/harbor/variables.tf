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

variable "git_source" {
  nullable = false
  type = object({
    branch     = optional(string, "main")
    repository = string
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

variable "state_force_write_mark" {
  default = "magic word"
  type    = string
}
