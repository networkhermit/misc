variable "dex_secret" {
  default  = {}
  nullable = false
  type = map(
    object({
      dex_credential = object({
        GITHUB_CLIENT_ID     = string
        GITHUB_CLIENT_SECRET = string
      })
      static_clients = optional(map(string), {})
    })
  )
}

variable "grafana_secret" {
  default  = {}
  nullable = false
  type = map(
    object({
      grafana_credential = object({
        ADMIN_USER     = string
        ADMIN_PASSWORD = string
      })
    })
  )
}

variable "harbor_secret" {
  default  = {}
  nullable = false
  type = map(
    object({
      harbor = object({
        HARBOR_ADMIN_PASSWORD         = string
        REGISTRY_HTPASSWD             = string
        REGISTRY_PASSWD               = string
        REGISTRY_STORAGE_S3_ACCESSKEY = string
        REGISTRY_STORAGE_S3_SECRETKEY = string
        SECRET_KEY                    = string
      })
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
