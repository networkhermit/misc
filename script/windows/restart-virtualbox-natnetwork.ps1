Push-Location $Env:VBOX_MSI_INSTALL_PATH
.\VBoxManage natnetwork stop --netname NatNetwork && .\VBoxManage natnetwork start --netname NatNetwork
Pop-Location
