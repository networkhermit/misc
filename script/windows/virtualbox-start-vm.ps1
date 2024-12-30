Push-Location $Env:VBOX_MSI_INSTALL_PATH
.\VBoxManage list runningvms
.\VBoxManage startvm --type headless arch
Pop-Location
