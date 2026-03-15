#resource "doppler_config" "local_k3s_dex_secret" {
#  environment = doppler_environment.local_k3s.slug
#  name        = "${doppler_environment.local_k3s.slug}_dex_secret"
#  project     = doppler_project.infra.id
#
#  lifecycle {
#    enabled = contains(keys(var.dex_secret), doppler_environment.local_k3s.slug)
#  }
#}

resource "doppler_secret" "local_k3s_dex_secret" {
  for_each = merge(try(var.dex_secret[doppler_environment.local_k3s.slug].dex_credential, {}), try(var.dex_secret[doppler_environment.local_k3s.slug].static_clients, {}))

  #config  = doppler_config.local_k3s_dex_secret.name
  config  = "${doppler_environment.local_k3s.slug}_dex_secret"
  name    = each.key
  project = doppler_project.infra.id
  value   = each.value
}

resource "doppler_service_token" "local_k3s_dex_secret" {
  access = "read"
  #config  = doppler_config.local_k3s_dex_secret.name
  config = "${doppler_environment.local_k3s.slug}_dex_secret"
  #name    = doppler_config.local_k3s_dex_secret.environment
  name    = doppler_environment.local_k3s.slug
  project = doppler_project.infra.id

  lifecycle {
    enabled = contains(keys(var.dex_secret), doppler_environment.local_k3s.slug)
  }
}
