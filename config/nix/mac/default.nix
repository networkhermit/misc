with import <nixpkgs> {config.allowUnfree = true;}; let
  base = [
    ansible
    ansible-lint
    b3sum
    bash-completion
    bashInteractive
    bat
    biome
    black
    cargo
    clippy
    cmatrix
    coreutils
    cowsay
    eza
    fd
    file
    findutils
    fortune
    fzf
    gawk
    gnugrep
    gnused
    gnutar
    go
    go-tools
    golangci-lint
    gopls
    gzip
    hexyl
    htop
    jq
    ldns
    less
    lua-language-server
    mold
    moreutils
    mypy
    neofetch
    neovim
    python3
    python311Packages.pytest
    ripgrep
    ruff
    ruff-lsp
    rust-analyzer
    rust.packages.stable.rustPlatform.rustcSrc
    rustc
    rustfmt
    sccache
    shellcheck
    sl
    stylua
    tmux
    tree
    watch
    xz
    yamllint
    yq-go
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
  devops = [
    _1password
    hyperfine
    kubebuilder
    kubectl
    kubernetes-helm
    kubie
    mitmproxy
    nmap
    opentofu
    sqlfluff
    tailspin
    terraform-ls
    tflint
    trivy
  ];
  nix = [alejandra];
  list = base ++ devops ++ nix;
in
  list
