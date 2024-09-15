```bash
# shellcheck shell=bash

nix-channel --add https://nixos.org/channels/nixpkgs-unstable

nix-channel --update
nix-env --query --available --file default.nix
nix-env --install --remove-all --file default.nix
nix-env --delete-generations old
nix-collect-garbage --delete-old

nix-env --query | sort

# multi-user upgrade
sudo su
nix-channel --update
nix-env --install --file '<nixpkgs>' --attr nixVersions.latest cacert -I nixpkgs=channel:nixpkgs

## Linux
systemctl daemon-reload
systemctl restart nix-daemon

## macOS
launchctl remove org.nixos.nix-daemon
launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
```
