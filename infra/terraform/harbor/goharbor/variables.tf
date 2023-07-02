variable "proxy_cache_accounts" {
  default  = {}
  nullable = false
  type = map(
    object({
      secret = string
    })
  )
}
