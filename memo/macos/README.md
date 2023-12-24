```bash
defaults delete com.apple.dock tilesize && killall Dock
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain AppleShowAllExtensions -bool true && killall Finder
defaults write com.apple.dock ResetLaunchPad -bool true && killall Dock
defaults write com.apple.dock autohide -bool true && killall Dock
defaults write com.apple.dock show-recents -bool false && killall Dock
```

```bash
defaults write com.apple.dock persistent-apps -array && killall Dock
```

```bash
sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder
```
