with import <nixpkgs> {config.allowUnfree = true;}; let
  base = [
    bat
    golangci-lint
    ruff
    rust-analyzer
    yq-go
  ];
  blog = [zola];
  devops = [
    _1password
    age
    cilium-cli
    conftest
    cue
    fluxcd
    hubble
    istioctl
    kubectl
    kubernetes-helm
    kubescape
    kubie
    nerdctl
    nickel
    open-policy-agent
    pulumi
    rage
    sops
    talosctl
    terraform
    tflint
    tfsec
    topiary
    weave-gitops
  ];
  nix = [alejandra];
  list = base ++ blog ++ devops ++ nix;
in
  list
