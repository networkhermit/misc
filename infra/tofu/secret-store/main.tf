resource "doppler_project" "infra" {
  name = "infra"
}

resource "doppler_environment" "local_k3s" {
  name    = "local-k3s"
  project = doppler_project.infra.id
  slug    = "local-k3s"
}
