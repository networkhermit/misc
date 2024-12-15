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
