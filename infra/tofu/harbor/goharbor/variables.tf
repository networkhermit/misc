variable "oidc_credential" {
  default   = null
  nullable  = true
  sensitive = true
  type = object({
    admin_group   = string
    client_id     = string
    client_secret = string
    endpoint      = string
  })
}

variable "proxy_cache_accounts" {
  default   = {}
  nullable  = false
  sensitive = true
  type = map(
    object({
      secret = string
    })
  )
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
