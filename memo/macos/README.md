```bash
# shellcheck shell=bash

# set user defaults

defaults delete com.apple.dock tilesize && killall Dock
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain AppleShowAllExtensions -bool true && killall Finder
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.dock ResetLaunchPad -bool true && killall Dock
defaults write com.apple.dock autohide -bool true && killall Dock
defaults write com.apple.dock show-recents -bool false && killall Dock
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

defaults write com.apple.dock persistent-apps -array && killall Dock

# disable startup sound

sudo nvram StartupMute=%01

# flush dns cache

sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder

# reset launchpad in sequoia

sudo find /private/var/folders/ -type d -name com.apple.dock.launchpad -exec rm -rf {} + 2>/dev/null; killall Dock
```
