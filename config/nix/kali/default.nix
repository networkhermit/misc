with import <nixpkgs> {config.allowUnfree = true;}; let
  base = [
    #uutils-coreutils (rust-coreutils)
    biome
    go-tools
    golangci-lint
    lua-language-server
    neovim
    pwru
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
    #hyperfine
    #kubernetes-helm
    #tetragon
    #trivy
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
    rage
    sops
    sqlfluff
    tailspin
    talosctl
    terraform-ls
    tflint
  ];
  nix = [alejandra];
  list = base ++ blog ++ devops ++ nix;
in
  list
