variable "cluster_endpoint" {
  type = string
}

variable "cluster_domain" {
  default = "cluster.local"
  type    = string
}

variable "flux_bootstrap_git_path" {
  default = "clusters/default"
  type    = string
}
