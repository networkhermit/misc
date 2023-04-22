resource "tls_private_key" "dummy" {
  algorithm = "ED25519"
}

resource "digitalocean_ssh_key" "dummy" {
  name       = "${var.cluster_name}-dummy"
  public_key = resource.tls_private_key.dummy.public_key_openssh
}
