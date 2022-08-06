#請將IP位置換成自己的NBminer的LAN網站IP位置
$webResponse = Invoke-WebRequest http://{IP位置}/api/v1/status

#利用正規表示式規則比對，如果礦機呈現的數值不對，則會有下一步通知。
$totalHashRate = $webResponse.RawContent -match "`"total_hashrate`":`"{正規表示式規則}`""
$result = if ($totalHashRate -eq $true) {write-output "功能正常"} else {write-output "功能不正常"}

#這邊的用意是提取hashrate，讓Gmail在通知時能一併附上當前的hashrate。
$hashrate = Invoke-RestMethod 'http://{IP位置}/api/v1/status'
$hashrate = $hashrate.miner.total_hashrate -replace ' M', ''

#寄送mail的部分
$mail = if ($result -eq "功能不正常") {
    #請將下列改為自己的帳戶密碼
    $userName = 'XXXXXX@gmail.com'
    $passWord = 'XXXXXX'
    [SecureString]$securepassword = $password | ConvertTo-SecureString -AsPlainText -Force 
    $credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securepassword
    #可以使用兩個不同的信箱寄信，或是使用一個信箱，自己寄給自己也行。
    Send-MailMessage -SmtpServer smtp.gmail.com -Port 587 -UseSsl -From XXXXXX@gmail.com -To OOOOOO@gapp.nthu.edu.tw -Subject "目前的Hashrate是$hashrate，挖礦出現問題啦" -Body '趕快去看看！' -Credential $credential -Encoding UTF8
    }
$mail

#撰寫檢查日誌，這邊預設路徑是放在桌面，如果要放在其他的位置，記得修改路徑。
$LogFile = "C:\Users\$env:UserName\Desktop\MiningCheckLog.txt"
function LogMessage
{
    param([string]$Message, [string]$LogFile)
    
    ((Get-Date).ToString() + " - " + $Message) >> $LogFile;
}
 
#如果日誌存在則刪除，這function我沒有使用，因為我想要保留所有的日誌，供日後分析使用。
function DeleteLogFile
{
    param([string]$LogFile)
    
    #Delete log file if it exists
    if(Test-Path $LogFile)
    {
        Remove-Item $LogFile
    }
} 

function WriteLog
{
   param([string]$Message) 
 
   LogMessage -Message $Message -LogFile $LogFile
}

WriteLog -Message "{檢查時間 : $((Get-Date).ToString()), 檢查結果 : $result, Total_Hashrate : $hashrate}"
