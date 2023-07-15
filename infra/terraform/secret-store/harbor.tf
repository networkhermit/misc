resource "doppler_environment" "harbor" {
  name    = "harbor"
  project = doppler_project.infra.id
  slug    = "harbor"
}

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

resource "doppler_config" "harbor_minio_secret" {
  count = lookup(var.harbor_secret, doppler_environment.harbor.slug, null) != null ? 1 : 0

  environment = doppler_environment.harbor.slug
  name        = "${doppler_environment.harbor.slug}_minio_secret"
  project     = doppler_project.infra.id
}

resource "doppler_secret" "harbor_minio_secret" {
  for_each = try(var.harbor_secret[doppler_environment.harbor.slug].minio, {})

  config  = doppler_config.harbor_minio_secret[0].name
  name    = each.key
  project = doppler_project.infra.id
  value   = each.value
}

resource "doppler_service_token" "harbor_minio_secret" {
  count = lookup(var.harbor_secret, doppler_environment.harbor.slug, null) != null ? 1 : 0

  access  = "read"
  config  = doppler_config.harbor_minio_secret[0].name
  name    = doppler_config.harbor_minio_secret[0].environment
  project = doppler_project.infra.id
}
