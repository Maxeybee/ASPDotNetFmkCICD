Invoke-Command -ComputerName $env:COMPUTERNAME -ScriptBlock {
    $bitness = ([System.IntPtr]::size * 8) 
    Write-Output "PowerShell is $bitness-bit"
    
    Write-Host 'Get Web App MyWindDashboard'
    Get-WebApplication 'MyWindDashboard'
    Write-Host 'End Web App MyWindDashboard'
    
    try {
        Remove-WebApplication -Name 'MyWindDashboard' -Site 'Default Web Site'
        Write-Host 'MyWindDashboard Web App Removed'
    } catch{
        Write-Host "Eror Occured" -BackgroundColor DarkRed
    }

}