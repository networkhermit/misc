resource "digitalocean_custom_image" "talos" {
  distribution = "Unknown OS"
  name         = "Talos ${var.talos_version}"
  regions      = [var.region]
  tags         = [digitalocean_tag.talos.name]
  url          = "https://github.com/siderolabs/talos/releases/download/${var.talos_version}/digital-ocean-amd64.raw.gz"
}
