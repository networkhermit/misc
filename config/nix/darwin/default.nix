with import <nixpkgs> {config.allowUnfree = true;}; let
  base = [
    #curl
    #git
    #lsof
    #man
    #openssh
    #rsync
    #vim
    #zsh
    ansible
    ansible-lint
    b3sum
    bash-completion
    bashInteractive
    bat
    biome
    black
    cargo
    cargo-audit
    cargo-outdated
    clippy
    cmatrix
    cowsay
    delve
    eza
    fd
    fish
    fortune
    fzf
    go
    go-tools
    golangci-lint
    gopls
    hexyl
    htop
    jq
    ldns
    lua-language-server
    mold
    moreutils
    mypy
    neovim
    python3
    python311Packages.argcomplete
    python311Packages.pip
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
    uutils-coreutils
    watch
    yamllint
    yq-go
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
