locals {
  addon_override = {
    cilium = [file("${path.module}/../../manifest/cilium-talos.yaml")]
    flux = {
      watch_path = "clusters/${local.cluster_name}"
    }
  }
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
      kubernetes = "1.27.4"
      talos      = "v1.4.7"
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
