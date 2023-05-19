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

variable "config_patches" {
  default  = []
  nullable = false
  type     = list(string)
}

variable "control_plane_nodes" {
  default  = { "control_plan" : "172.31.0.10" }
  nullable = false
  type     = map(string)
}

variable "kubernetes_version" {
  default  = "1.27.1"
  nullable = false
  type     = string
}

variable "talos_version" {
  default  = "v1.4.4"
  nullable = false
  type     = string
}

variable "worker_nodes" {
  default  = { "worker" : "172.31.0.11" }
  nullable = false
  type     = map(string)
}
