variable "DIGITALOCEAN_TOKEN" {
  sensitive = true
  type      = string
}

variable "GITHUB_OWNER" {
  type = string
}

variable "GITHUB_TOKEN" {
  sensitive = true
  type      = string
}

variable "github_branch" {
  default = "main"
  type    = string
}

variable "github_repository" {
  type = string
}
