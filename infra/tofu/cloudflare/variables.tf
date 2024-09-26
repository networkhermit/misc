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

variable "zone_records" {
  nullable = false
  type = object({
    domain = string
    records = list(
      object({
        content  = string
        name     = string
        priority = optional(number)
        ttl      = number
        type     = string
        uuid     = string
      })
    )
  })
}
