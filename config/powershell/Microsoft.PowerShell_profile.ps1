Set-PSReadLineOption -EditMode Emacs

function s {
    Set-Location ..
}

Set-Alias -Name v -Value vim

function sha {
    param(
        [Parameter(Mandatory)]
        [string]$file
    )
    Get-FileHash -Algorithm SHA256 $file
}

function clip {
    param(
        [Parameter(Mandatory)]
        [string]$file
    )
    Get-Content $file | Set-Clipboard
}

Set-Alias -Name open -Value start
