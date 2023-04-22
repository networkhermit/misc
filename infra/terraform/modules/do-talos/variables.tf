variable "cluster_name" {
  default  = "talos-default"
  nullable = false
  type     = string
}

variable "control_plane_count" {
  default  = 1
  nullable = false
  type     = number
}

variable "control_plane_type" {
  default  = "s-2vcpu-2gb"
  nullable = false
  type     = string
}

variable "extra_internal_allowed_cidr" {
  default  = []
  nullable = false
  type     = list(string)
}

variable "kubernetes_api_allowed_cidr" {
  default  = ["0.0.0.0/0", "::/0"]
  nullable = false
  type     = list(string)
}

variable "kubernetes_api_lb_size" {
  default  = 1
  nullable = false
  type     = number
}

variable "worker_count" {
  default  = 1
  nullable = false
  type     = number
}

variable "worker_type" {
  default  = "s-2vcpu-4gb"
  nullable = false
  type     = string
}

variable "region" {
  default  = "sgp1"
  nullable = false
  type     = string
}

variable "talos_api_allowed_cidr" {
  default  = ["0.0.0.0/0", "::/0"]
  nullable = false
  type     = list(string)
}

variable "talos_version" {
  default  = "v1.4.0"
  nullable = false
  type     = string
}

variable "vpc_cidr" {
  default  = "172.31.0.0/24"
  nullable = false
  type     = string
}
