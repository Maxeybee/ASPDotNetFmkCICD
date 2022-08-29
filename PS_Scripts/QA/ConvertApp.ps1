Invoke-Command -ComputerName $env:COMPUTERNAME -ScriptBlock {
    $bitness = ([System.IntPtr]::size * 8) 
    Write-Output "PowerShell is $bitness-bit"
    
    [string]$path = "D:/inetpub/wwwroot/MyWindDashboard/"

    if(Test-Path $path){
        Write-Host "Folder MyWindDashboard Exists"
        Remove-WebApplication -Name 'MyWindDashboard' -Site 'Default Web Site'
        Write-Host 'MyWindDashboard Web App Removed'
        ConvertTo-WebApplication -ApplicationPool "DefaultAppPool" -PSPath "IIS:/Sites/Default Web Site/MyWindDashboard" -Force
    }
    
}