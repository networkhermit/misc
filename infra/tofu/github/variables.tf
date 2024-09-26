variable "GITHUB_OWNER" {
  nullable = false
  type     = string
}

variable "branch_protection" {
  default  = {}
  nullable = false
  type = map(
    object({
      pattern = string
      repo    = string
    })
  )
}

variable "default_branch" {
  default  = "main"
  nullable = false
  type     = string
}

variable "state_backend_s3_bucket" {
  type = string
}

variable "state_backend_s3_key" {
  type = string
}

variable "state_encryption_passphrase" {
  sensitive = true
  type      = string
}

variable "state_force_write_mark" {
  default = "magic word"
  type    = string
}

variable "team_members" {
  default  = {}
  nullable = false
  type = map(
    list(
      object({
        role     = optional(string, "member")
        username = string
      })
    )
  )
}
