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
