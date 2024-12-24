Push-Location $Env:USERPROFILE\git
Get-ChildItem -Directory | ForEach-Object{ git -C $_ gc; git -C $_ submodule foreach git gc }
Pop-Location
