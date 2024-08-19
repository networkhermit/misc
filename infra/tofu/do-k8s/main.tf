locals {
  cluster_domain = "${local.cluster_name}.local"
  cluster_name   = "fleet"
  infra = {
    cluster_spec = {
      control_plane = {
        count = 3
      }
      worker = {
        count = 3
        type  = "s-4vcpu-8gb-amd"
      }
    }
    firewall_allowlist = {
      internal = ["10.24.0.0/16"]
    }
    pinned_version = {
      kubernetes = "1.30.3"
      talos      = "v1.7.6"
    }
  }
  talos_override = {
    machine = [
      yamlencode({
        cluster = {
          allowSchedulingOnControlPlanes = false
        }
      })
    ]
  }
}
