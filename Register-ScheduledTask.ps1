$Trigger= New-ScheduledTaskTrigger -Once -At (get-date) -RepetitionInterval (New-TimeSpan -Minutes 30)
$ComputerUser= [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$Action= New-ScheduledTaskAction -Execute "Powershell.exe" -Argument "-NoProfile -NoLogo -NonInteractive -ExecutionPolicy Bypass C:\Users\$env:UserName\Desktop\miningCheck\MiningCheck.ps1"
Register-ScheduledTask -TaskName "Mining_Check" -Trigger $Trigger -User $ComputerUser -Action $Action -RunLevel Highest –Force