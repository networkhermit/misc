Set-PSReadlineOption -HistorySaveStyle SaveNothing
# (Get-PSReadlineOption).HistorySaveStyle
#Remove-Item -ErrorAction Ignore -Force (Get-PSReadlineOption).HistorySavePath

Write-Output @"

The programs included with the Kali GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Kali GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
"@
