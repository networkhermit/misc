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
      minio = object({
        ROOT_PASSWORD = string
        ROOT_USER     = string
      })
    })
  )
}

variable "weave_gitops_secret" {
  default  = {}
  nullable = false
  type = map(
    object({
      cluster_user_auth = object({
        PASSWORD = string
        USERNAME = string
      })
    })
  )
}
