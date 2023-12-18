resource "doppler_project" "infra" {
  name = "infra"
}

resource "doppler_environment" "harbor" {
  name    = "harbor"
  project = doppler_project.infra.id
  slug    = "harbor"
}
