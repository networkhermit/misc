# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: let
  hostname = "nixos";
  user = "vac";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./git/config/etc/nixos/options.nix
    ./git/config/vault/${hostname}
  ];

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

  #boot.initrd.checkJournalingFS = false;
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.consoleLogLevel = 7;
  boot.kernelParams = ["console=ttyS0,115200n8"];
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.timeout = 1;
  boot.tmp.useTmpfs = true;

  boot.kernel.sysctl = {
    "net.ipv4.tcp_base_mss" = 1024;
    "net.ipv4.tcp_mtu_probing" = 1;

    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_fastopen" = 3;
  };

  boot.kernelModules =
    if config.local.useVirtualPHC
    then ["ptp_kvm"]
    else [];

  console.font = "eurlatgr";

  environment.etc = {
    "gai.conf" = {
      source = ./git/config/etc/gai.conf;
    };
    "resolv.conf" =
      if config.networking.nameservers != []
      then {
        text = ''
          options attempts:3 rotate timeout:1 use-vc

          ${builtins.concatStringsSep "\n" (map (x: "nameserver ${x}") config.networking.nameservers)}
          ${
            if config.networking.search != []
            then "search " + toString config.networking.search
            else ""
          }
        '';
      }
      else {
        source =
          ./git/config/etc/resolv.conf
          + (
            if config.local.direct
            then ""
            else ".alt"
          );
      };
  };

  environment.systemPackages = with pkgs; [
    bashInteractive
    bash-completion
    fish
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    man
    man-pages
    texinfoInteractive
    vim
    emacs-nox
    shellcheck

    b3sum
    bat
    eza
    fd
    fzf
    hexyl
    jq
    moreutils
    ripgrep
    tree
    yq-go

    cron
    htop
    iotop-c
    lsof
    sysstat
    tmux

    chrony
    curl
    ldns
    openssh
    rsync

    go
    gopls
    go-tools
    delve
    golangci-lint
    python3
    black
    python311Packages.pip
    mypy
    ruff
    ruff-lsp
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    cargo-audit
    cargo-outdated
    mold
    sccache

    cmatrix
    cowsay
    fortune
    sl

    ansible
    ansible-lint
    yamllint
    python311Packages.argcomplete
    bcc
    bpftools
    bpftrace
    docker
    docker-compose
    git
    linuxKernel.packages.linux_libre.perf
    wireguard-tools

    biome
    file
    lua-language-server
    neovim
    stylua
    uutils-coreutils

    zola

    #_1password
    age
    cilium-cli
    conftest
    cue
    fluxcd
    hubble
    hyperfine
    istioctl
    k9s
    kubebuilder
    kubectl
    kubernetes-helm
    kubescape
    kubie
    nerdctl
    nickel
    open-policy-agent
    opentofu
    rage
    sops
    sqlfluff
    tailscale
    tailspin
    talosctl
    terraform-ls
    tflint
    trivy

    alejandra

    avahi
    nssmdns
  ];

  environment.wordlist.enable = true;

  i18n.extraLocaleSettings = {
    LC_COLLATE = "C.UTF-8";
  };

  networking.hostName = "nixos";

  networking.timeServers =
    ["time.cloudflare.com"]
    ++ (
      if config.local.direct
      then ["time.google.com"]
      else ["time.apple.com"]
    );

  networking.wg-quick.interfaces = let
    wg = config.local.wireguard;
  in {
    wg0 = {
      address = wg.address;
      peers = map (p:
        {
          persistentKeepalive = 15;
        }
        // p)
      wg.peers;
      privateKeyFile = wg.privateKeyFile or "/etc/wireguard/private.key";
    };
  };

  nix.settings = {
    auto-optimise-store = true;
    connect-timeout = 10;
    experimental-features = ["nix-command" "flakes"];
    substituters =
      if config.local.direct
      then []
      else [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10"
        "https://mirrors.ustc.edu.cn/nix-channels/store?priority=15"
        "https://mirror.sjtu.edu.cn/nix-channels/store?priority=20"
      ];
    keep-outputs = true;
    stalled-download-timeout = 30;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "1password-cli"
    ];

  programs.fish.enable = true;
  programs.git.enable = true;
  programs.git.prompt.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;

  security.sudo = {
    extraConfig = ''
      Defaults secure_path="/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/home/${user}/STEM/sbin"
      Defaults mail_badpass
      Defaults env_reset
      Defaults timestamp_timeout=5
      Defaults use_pty
    '';
    extraRules = [
      {
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
        host = "ALL";
        runAs = "ALL:ALL";
        users = [config.local.ansibleUser];
      }
    ];
  };

  services.cron.enable = true;
  services.tailscale.enable = true;
  services.timesyncd.enable = false;

  services.avahi = {
    enable = true;
    ipv6 = true;
    nssmdns4 = true;
    nssmdns6 = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  services.chrony = let
    baseConfig = builtins.readFile ./git/config/etc/chrony.d/10-local.conf;
  in
    {
      enable = true;
      enableRTCTrimming = false;
      extraConfig = baseConfig;
    }
    // (
      if config.local.useVirtualPHC
      then {
        servers = [];
        extraConfig = ''
          ${baseConfig}

          ${builtins.readFile ./git/config/etc/chrony.d/10-source-phc.conf}
        '';
      }
      else {}
    );

  services.journald.extraConfig = ''
    MaxRetentionSec=30day
  '';

  services.openssh = {
    hostKeys = [
      {
        comment = "sysadmin@${hostname}";
        path = "/etc/ssh/ssh_host_ed25519_key";
        rounds = 100;
        type = "ed25519";
      }
      {
        bits = 4096;
        comment = "sysadmin@${hostname}";
        path = "/etc/ssh/ssh_host_rsa_key";
        rounds = 100;
        type = "rsa";
      }
    ];
    settings = {
      AllowGroups = ["sysadmin"];
      ClientAliveInterval = 20;
      LogLevel = "VERBOSE";
      LoginGraceTime = "30s";
      PasswordAuthentication = false;
      PermitRootLogin = "no";

      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
        "aes256-ctr"
        "aes192-ctr"
        "aes128-ctr"
      ];
      KexAlgorithms = [
        "sntrup761x25519-sha512@openssh.com"
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group18-sha512"
        "diffie-hellman-group16-sha512"
      ];
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];
    };
    enable = true;
    ports = [321];
  };

  system.nssDatabases.hosts = lib.mkAfter ["[!UNAVAIL=return]"];

  systemd.oomd.enable = false;

  time.timeZone = "Asia/Shanghai";

  users.groups = {
    sysadmin = {
      gid = 256;
    };
    ${user} = {
      gid = 1000;
    };
    ${config.local.ansibleUser} = {
      gid = 8128;
    };
  };

  users.motd = with builtins; replaceStrings ["OS_RELEASE_NAME"] ["NixOS"] (readFile ./git/config/etc/motd);

  users.users = let
    ansibleUser = config.local.ansibleUser;
  in {
    ${user} = {
      autoSubUidGidRange = true;
      createHome = true;
      extraGroups = ["wheel" "sysadmin"];
      group = "${user}";
      home = "/home/${user}";
      isNormalUser = true;
      openssh.authorizedKeys.keyFiles = [
        ./git/config/vault/authorized_keys.d/${hostname}/${user}
      ];
      shell = pkgs.zsh;
      uid = 1000;
    };
    ${ansibleUser} = {
      createHome = true;
      extraGroups = ["wheel" "sysadmin"];
      group = ansibleUser;
      home = "/home/${ansibleUser}";
      isSystemUser = true;
      openssh.authorizedKeys.keyFiles = [
        ./git/config/vault/authorized_keys.d/${hostname}/${ansibleUser}
      ];
      shell = pkgs.bashInteractive;
      uid = 8128;
    };
  };

  zramSwap = {
    enable = true;
    memoryMax = 8 * 1024 * 1024 * 1024;
    memoryPercent = 100;
  };
}
