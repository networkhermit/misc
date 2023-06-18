variable "acme_clients" {
  default  = []
  nullable = false
  type = list(
    object({
      expires_on = optional(string)
      name       = string
      not_before = optional(string)
      uuid       = string
    })
  )
}

variable "cloudflare_account_name" {
  nullable = false
  type     = string
}

variable "domain" {
  nullable = false
  type     = string
}

variable "records" {
  default  = []
  nullable = false
  type = list(
    object({
      name     = string
      priority = optional(number)
      ttl      = number
      type     = string
      uuid     = string
      value    = string
    })
  )
}
