with import <nixpkgs> {config.allowUnfree = true;}; let
  base = [
    bat
    biome
    go-tools
    golangci-lint
    lua-language-server
    neovim
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
    kubebuilder
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
