resource "doppler_config" "harbor_dex_secret" {
  count = lookup(var.dex_secret, doppler_environment.harbor.slug, null) != null ? 1 : 0

  environment = doppler_environment.harbor.slug
  name        = "${doppler_environment.harbor.slug}_dex_secret"
  project     = doppler_project.infra.id
}

resource "doppler_secret" "harbor_dex_secret" {
  for_each = merge(try(var.dex_secret[doppler_environment.harbor.slug].dex_credential, {}), try(var.dex_secret[doppler_environment.harbor.slug].static_clients, {}))

  config  = doppler_config.harbor_dex_secret[0].name
  name    = each.key
  project = doppler_project.infra.id
  value   = each.value
}

resource "doppler_service_token" "harbor_dex_secret" {
  count = lookup(var.dex_secret, doppler_environment.harbor.slug, null) != null ? 1 : 0

  access  = "read"
  config  = doppler_config.harbor_dex_secret[0].name
  name    = doppler_config.harbor_dex_secret[0].environment
  project = doppler_project.infra.id
}
