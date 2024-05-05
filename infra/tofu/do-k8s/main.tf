locals {
  addon_override = {
    cilium = [
      file("${path.module}/../../manifest/cilium-talos.yaml"),
      yamlencode({
        enableIPv4BIGTCP = false
        ipv6 = {
          enabled = false
        }
        loadBalancer = {
          acceleration = "native"
        }
      })
    ]
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
      kubernetes = "1.30.0"
      talos      = "v1.7.1"
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
