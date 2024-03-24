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
