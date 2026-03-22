locals {
  addon_override = {
    cilium = [
      yamlencode({
        bpf = {
          datapathMode = "netkit"
        }
        cni = {
          exclusive = false
        }
        devices               = var.cluster_specific.cilium_devices
        ipv4NativeRoutingCIDR = "10.42.0.0/16"
        loadBalancer = {
          mode = "hybrid"
        }
      }),
      yamlencode({
        gatewayAPI = {
          enabled = false
        }
        l7Proxy = false
      }),
    ]
    flux = {
      kustomization_override = file("${path.module}/../../manifest/flux-kustomization.yaml")
    }
  }
  registry_mirror = var.registry_mirror == null ? {} : {
    ghcr = "${var.registry_mirror.host}/ghcr.io"
    quay = "${var.registry_mirror.host}/quay.io"
  }
}
