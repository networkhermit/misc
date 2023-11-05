with import <nixpkgs> {config.allowUnfree = true;}; let
  base = [
    bat
    go-tools
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
    #age
    #cilium-cli
    #hubble
    #kubernetes-helm
    #tetragon
    _1password
    conftest
    cue
    fluxcd
    istioctl
    kubectl
    kubescape
    kubie
    nerdctl
    nickel
    open-policy-agent
    opentofu
    pulumi
    rage
    sops
    talosctl
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
