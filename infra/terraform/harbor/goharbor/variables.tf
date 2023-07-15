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
