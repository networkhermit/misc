resource "doppler_config" "harbor_harbor_secret" {
  count = lookup(var.harbor_secret, doppler_environment.harbor.slug, null) != null ? 1 : 0

  environment = doppler_environment.harbor.slug
  name        = "${doppler_environment.harbor.slug}_harbor_secret"
  project     = doppler_project.infra.id
}

resource "doppler_secret" "harbor_harbor_secret" {
  for_each = try(var.harbor_secret[doppler_environment.harbor.slug].harbor, {})

  config  = doppler_config.harbor_harbor_secret[0].name
  name    = each.key
  project = doppler_project.infra.id
  value   = each.value
}

resource "doppler_service_token" "harbor_harbor_secret" {
  count = lookup(var.harbor_secret, doppler_environment.harbor.slug, null) != null ? 1 : 0

  access  = "read"
  config  = doppler_config.harbor_harbor_secret[0].name
  name    = doppler_config.harbor_harbor_secret[0].environment
  project = doppler_project.infra.id
}
