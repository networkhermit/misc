Set-Alias -Name v -Value gvim

function s {
    Set-Location ..
}

function sh {
    Push-Location $Env:HOME
}
