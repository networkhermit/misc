variable "GITHUB_OWNER" {
  nullable = false
  type     = string
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

variable "git_source" {
  nullable = false
  type = object({
    branch     = optional(string, "main")
    repository = string
  })
}
