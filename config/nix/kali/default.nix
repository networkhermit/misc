with import <nixpkgs> {config.allowUnfree = true;}; let
  base = [
    bat
    golangci-lint
    lua-language-server
    neovim
    rome
    ruff
    ruff-lsp
    rust-analyzer
    stylua
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
    terraform-ls
    tflint
    tfsec
    topiary
    weave-gitops
  ];
  nix = [alejandra];
  list = base ++ blog ++ devops ++ nix;
in
  list
