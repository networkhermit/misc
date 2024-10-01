variable "addon_override" {
  default  = {}
  nullable = false
  type = object({
    cilium = optional(list(string), [])
    flux = optional(object({
      watch_path = optional(string, "clusters/default")
    }), {})
    kubelet_csr_approver = optional(list(string), [])
  })
}

variable "cluster_domain" {
  default  = "cluster.local"
  nullable = false
  type     = string
}

variable "cluster_endpoint" {
  nullable = false
  type     = string
}

variable "cluster_name" {
  default  = "default"
  nullable = false
  type     = string
}

variable "pinned_version" {
  default  = {}
  nullable = false
  type = object({
    cilium                   = optional(string, "1.16.2")
    kubelet_csr_approver     = optional(string, "1.2.2")
    prometheus_operator_crds = optional(string, "14.0.0")
  })
}
