variable "cluster_name" {
  default  = "talos-default"
  nullable = false
  type     = string
}

variable "cluster_spec" {
  default  = {}
  nullable = false
  type = object({
    control_plane = optional(object({
      count = optional(number, 1)
      type  = optional(string, "s-2vcpu-2gb")
    }), {})
    lb = optional(object({
      size = optional(number, 1)
    }), {})
    worker = optional(object({
      count = optional(number, 1)
      type  = optional(string, "s-2vcpu-4gb")
    }), {})
  })
}

variable "firewall_allowlist" {
  default  = {}
  nullable = false
  type = object({
    internal  = optional(list(string), [])
    k8s_api   = optional(list(string), ["0.0.0.0/0", "::/0"])
    talos_api = optional(list(string), ["0.0.0.0/0", "::/0"])
  })
}

variable "pinned_version" {
  default  = {}
  nullable = false
  type = object({
    talos = optional(string, "v1.4.7")
  })
}

variable "region" {
  default  = "sgp1"
  nullable = false
  type     = string
}

variable "vpc_cidr" {
  default  = "172.31.0.0/24"
  nullable = false
  type     = string
}

