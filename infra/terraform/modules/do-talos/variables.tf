variable "cluster_name" {
  default  = "talos-default"
  nullable = false
  type     = string
}

variable "control_plane_spec" {
  default = {
    count = 1
    type  = "s-2vcpu-2gb"
  }
  nullable = false
  type = object({
    count = number
    type  = string
  })
}

variable "extra_internal_cidr" {
  default  = []
  nullable = false
  type     = list(string)
}

variable "k8s_api_allowed_cidr" {
  default  = ["0.0.0.0/0", "::/0"]
  nullable = false
  type     = list(string)
}

variable "k8s_api_lb_size" {
  default  = 1
  nullable = false
  type     = number
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
  default  = "v1.4.4"
  nullable = false
  type     = string
}

variable "vpc_cidr" {
  default  = "172.31.0.0/24"
  nullable = false
  type     = string
}

variable "worker_spec" {
  default = {
    count = 1
    type  = "s-2vcpu-4gb"
  }
  nullable = false
  type = object({
    count = number
    type  = string
  })
}

