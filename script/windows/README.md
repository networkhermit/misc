```powershell
# Powershell Profile
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Get-ExecutionPolicy -List

Get-Content $PROFILE.AllUsersAllHosts

New-Item -Force -ItemType File -Path $PROFILE.CurrentUserCurrentHost
Get-Content $PROFILE.CurrentUserCurrentHost

# Windows Service Management
Get-Service
Get-Service | Where-Object {$_.Status -eq 'Running'}
Get-Service | Sort-Object Status,Name

# Windows Time Service
reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers
Get-ItemProperty -Path HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers

Set-ItemProperty -Name MaxPollInterval -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config -Value 10
Set-ItemProperty -Name MinPollInterval -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config -Value 6
Set-ItemProperty -Name UpdateInterval -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config -Value 100
Set-ItemProperty -Name NtpServer -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters -Value 'time1.apple.com,0x9'
Set-ItemProperty -Name SpecialPollInterval -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient -Value 900

Get-ItemProperty -Name MaxPollInterval -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config
Get-ItemProperty -Name MinPollInterval -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config
Get-ItemProperty -Name UpdateInterval -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config
Get-ItemProperty -Name NtpServer -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters
Get-ItemProperty -Name SpecialPollInterval -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient

Get-Service -Name W32Time
net stop W32Time && net start W32Time
Restart-Service -Name W32Time -PassThru

w32tm /query /configuration /verbose
w32tm /query /peers /verbose
w32tm /query /source /verbose
w32tm /query /status /verbose
```
