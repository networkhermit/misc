resource "terraform_data" "dummy" {
  triggers_replace = var.state_force_write_mark
}
