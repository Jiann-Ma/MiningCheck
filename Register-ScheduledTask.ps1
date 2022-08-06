#從現在的時間點開始，每30分鐘觸發一次。
$Trigger= New-ScheduledTaskTrigger -Once -At (get-date) -RepetitionInterval (New-TimeSpan -Minutes 30)
#用甚麼身分執行，這邊是抓當前登入電腦的身分。
$ComputerUser= [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
#要注意這邊的各種參數，比較重要的就是ExecutionPolicy這一塊，因為微軟預設是鎖住Powershell script的，要額外開啟。
$Action= New-ScheduledTaskAction -Execute "Powershell.exe" -Argument "-NoProfile -NoLogo -NonInteractive -ExecutionPolicy Bypass C:\Users\$env:UserName\Desktop\MiningCheck.ps1"
Register-ScheduledTask -TaskName "Mining_Check" -Trigger $Trigger -User $ComputerUser -Action $Action -RunLevel Highest –Force
