locals {
  addon = {
    cilium_override = [file("${path.module}/../../manifest/cilium-talos.yaml")]
  }
  cluster_dns_domain = "fleet.local"
  cluster_name       = "fleet"
  infra = {
    control_plane_spec = {
      count = 3
      type  = "s-2vcpu-2gb"
    }
    extra_internal_cidr = ["10.24.0.0/16"]
    kubernetes_version  = "1.27.3"
    talos_version       = "v1.4.6"
    worker_spec = {
      count = 3
      type  = "s-4vcpu-8gb-amd"
    }
  }
  talos = {
    machine_override = [
      yamlencode({
        cluster = {
          allowSchedulingOnControlPlanes = false
        }
      })
    ]
  }
}
