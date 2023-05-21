variable "cilium_override" {
  default  = []
  nullable = false
  type     = list(string)
}

variable "cluster_endpoint" {
  nullable = false
  type     = string
}

variable "cluster_domain" {
  default  = "cluster.local"
  nullable = false
  type     = string
}

variable "cluster_name" {
  default  = "default"
  nullable = false
  type     = string
}

variable "flux_git_repo_path" {
  default  = "clusters/default"
  nullable = false
  type     = string
}
