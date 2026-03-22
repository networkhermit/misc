variable "oidc_credential" {
  default  = null
  nullable = true
  type = object({
    admin_group = string
    endpoint    = string
  })
}

variable "oidc_credential_sensitive" {
  default   = null
  nullable  = true
  sensitive = true
  type = object({
    client_id     = string
    client_secret = string
  })
}

variable "proxy_cache_accounts" {
  default  = {}
  nullable = false
  type = map(
    object({
    })
  )
}

variable "proxy_cache_accounts_sensitive" {
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
