variable "acme_clients" {
  default = {
    environment = []
    project     = "example-project"
  }
  nullable = false
  type = object({
    environment = list(
      object({
        expires_on = optional(string)
        name       = string
        not_before = optional(string)
        uuid       = string
      })
    )
    project = string
  })
}

variable "cloudflare_account_name" {
  nullable = false
  type     = string
}

variable "zone_records" {
  nullable = false
  type = object({
    domain = string
    records = list(
      object({
        name     = string
        priority = optional(number)
        ttl      = number
        type     = string
        uuid     = string
        value    = string
      })
    )
  })
}
