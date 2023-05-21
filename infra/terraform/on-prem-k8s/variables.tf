variable "GITHUB_OWNER" {
  nullable = false
  type     = string
}

variable "GITHUB_TOKEN" {
  nullable  = false
  sensitive = true
  type      = string
}

variable "cluster_endpoint" {
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
