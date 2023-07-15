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
