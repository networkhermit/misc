locals {
  cluster_name             = "fleet"
  control_plane_count      = 1
  install_base_helm_charts = true
  kubernetes_version       = "1.27.1"
  talos_version            = "v1.4.0"
  worker_count             = 1
}

module "do_talos" {
  source = "../modules/do-talos"

  cluster_name                = local.cluster_name
  control_plane_count         = local.control_plane_count
  extra_internal_allowed_cidr = ["10.24.0.0/16"]
  talos_version               = local.talos_version
  worker_count                = local.worker_count
}

module "talos_bootstrap" {
  source = "../modules/talos-bootstrap"

  cluster_endpoint = module.do_talos.cluster_endpoint
  cluster_name     = local.cluster_name
  config_patches = [
    file("files/patch.yaml"),
    yamlencode({
      cluster = {
        allowSchedulingOnControlPlanes = true
      }
    })
  ]
  control_plane_nodes = module.do_talos.control_plane_nodes
  kubernetes_version  = local.kubernetes_version
  talos_version       = local.talos_version
  worker_nodes        = module.do_talos.worker_nodes
}

resource "local_sensitive_file" "kubeconfig" {
  count = local.control_plane_count > 0 ? 1 : 0

  content         = module.talos_bootstrap.kubeconfig
  file_permission = "0600"
  filename        = "vault/kubeconfig"
}

resource "local_sensitive_file" "talosconfig" {
  count = local.control_plane_count > 0 ? 1 : 0

  content         = module.talos_bootstrap.talosconfig
  file_permission = "0600"
  filename        = "vault/talosconfig"
}

resource "helm_release" "kubelet_csr_approver" {
  count      = local.install_base_helm_charts ? 1 : 0
  depends_on = [local_sensitive_file.kubeconfig]

  chart      = "kubelet-csr-approver"
  name       = "kubelet-csr-approver"
  namespace  = "kube-system"
  repository = "https://postfinance.github.io/kubelet-csr-approver"
  version    = "1.0.0"

  values = [
    yamlencode({
      bypassDnsResolution : true
    })
  ]
}

locals {
  k8sServiceCapture = regex("^https?://([0-9]+.[0-9]+.[0-9]+.[0-9]+):([0-9]+)$", module.talos_bootstrap.cluster_endpoint)
}

resource "helm_release" "cilium" {
  count      = local.install_base_helm_charts ? 1 : 0
  depends_on = [local_sensitive_file.kubeconfig]

  chart      = "cilium"
  name       = "cilium"
  namespace  = "kube-system"
  repository = "https://helm.cilium.io"
  version    = "1.13.2"

  values = [
    file("../../manifest/cilium.yaml"),
    yamlencode({
      cgroup = {
        autoMount = {
          enabled = false
        }
        hostRoot = "/sys/fs/cgroup"
      }
      ipv6 = {
        enabled = false
      }
      k8sServiceHost = local.k8sServiceCapture[0]
      k8sServicePort = local.k8sServiceCapture[1]
      loadBalancer = {
        acceleration : "native"
      }
      securityContext = {
        capabilities = {
          ciliumAgent      = ["CHOWN", "KILL", "NET_ADMIN", "NET_RAW", "IPC_LOCK", "SYS_ADMIN", "SYS_RESOURCE", "DAC_OVERRIDE", "FOWNER", "SETGID", "SETUID"]
          cleanCiliumState = ["NET_ADMIN", "SYS_ADMIN", "SYS_RESOURCE"]
        }
      }
    })
  ]
}
