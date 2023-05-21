resource "helm_release" "kubelet_csr_approver" {
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
  k8sServiceCapture = regex("^https?://([0-9]+.[0-9]+.[0-9]+.[0-9]+):([0-9]+)$", var.cluster_endpoint)
}

resource "helm_release" "cilium" {
  chart      = "cilium"
  name       = "cilium"
  namespace  = "kube-system"
  repository = "https://helm.cilium.io"
  version    = "1.14.0-snapshot.2"

  values = concat(
    [
      file("${path.module}/../../../manifest/cilium.yaml"),
      yamlencode({
        cluster = {
          name = var.cluster_name
        }
        k8sServiceHost = local.k8sServiceCapture[0]
        k8sServicePort = local.k8sServiceCapture[1]
      })
    ],
    var.cilium_override
  )
}

resource "flux_bootstrap_git" "fleet" {
  depends_on = [helm_release.cilium, helm_release.kubelet_csr_approver]

  cluster_domain = var.cluster_domain
  path           = var.flux_git_repo_path
}
