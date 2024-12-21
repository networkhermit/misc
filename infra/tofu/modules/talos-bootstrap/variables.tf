variable "cluster_domain" {
  default  = "cluster.local"
  nullable = false
  type     = string
}

variable "cluster_endpoint" {
  default  = "https://172.31.0.10:6443"
  nullable = false
  type     = string
}

variable "cluster_name" {
  default  = "talos-default"
  nullable = false
  type     = string
}

variable "node_list" {
  default  = {}
  nullable = false
  type = object({
    control_plane = optional(map(string), { control_plane = "172.31.0.10" })
    worker        = optional(map(string), { worker = "172.31.0.11" })
  })
}

variable "pinned_version" {
  default  = {}
  nullable = false
  type = object({
    kubernetes = optional(string, "1.32.0")
    talos      = optional(string, "v1.9.0")
  })
}

variable "talos_override" {
  default  = {}
  nullable = false
  type = object({
    control_plane = optional(list(string), [])
    machine       = optional(list(string), [])
    worker        = optional(list(string), [])
  })
}
