variable "DIGITALOCEAN_TOKEN" {
  nullable  = false
  sensitive = true
  type      = string
}

variable "GITHUB_OWNER" {
  nullable = false
  type     = string
}

variable "GITHUB_TOKEN" {
  nullable  = false
  sensitive = true
  type      = string
}

variable "KUBE_CONFIG_PATH" {
  default  = "vault/kubeconfig"
  nullable = false
  type     = string
}

variable "TALOSCONFIG" {
  default  = "vault/talosconfig"
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
