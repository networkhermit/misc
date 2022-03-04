Set-Alias -Name v -Value vim

function s {
    Set-Location ..
}

function sh {
    Push-Location $Env:HOME
}
