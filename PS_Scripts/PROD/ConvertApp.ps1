Invoke-Command -ComputerName $env:COMPUTERNAME -ScriptBlock {
    $bitness = ([System.IntPtr]::size * 8) 
    Write-Output "PowerShell is $bitness-bit"
    
    [string]$path = "D:/inetpub/MyWindDashboard/MyWindDashboard"

    if(Test-Path $path){
        Write-Host "Folder MyWindDashboard Exists"
        Remove-WebApplication -Name 'MyWindDashboard' -Site 'myportalgerenewableenergy'
        ConvertTo-WebApplication -ApplicationPool "myportalgerenewableenergy" -PSPath "IIS:/Sites/myportalgerenewableenergy/MyWindDashboard" -Force
    }
}