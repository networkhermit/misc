# schtasks /create /tn "$Env:USERNAME\Sync Git Repo" /sc daily /st 00:30 /ri 60 /du 24:00 /tr "pwsh.exe -Command sync-git-repo.ps1 -WindowStyle hidden" /np /f

Push-Location $Env:USERPROFILE\git
Get-ChildItem -Directory | ForEach-Object{ git -C $_ pull; git -C $_ submodule update --init }
Pop-Location
