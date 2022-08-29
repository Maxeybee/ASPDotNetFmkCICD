Invoke-Command -ComputerName $env:COMPUTERNAME -ScriptBlock {
    $bitness = ([System.IntPtr]::size * 8) 
    Write-Output "PowerShell is $bitness-bit"
    
    [string]$today = (Get-Date -Format "MM_dd_yyyy_HH_mm")
    [string]$folder = "MYPortal_"
    [string]$finalFolderName = $folder+$today
    
    Copy-Item -Path D:\inetpub\wwwroot\MyWindDashboard -Destination D:\inetpub\wwwroot\MyWindDashboardBackup\MyWindDashboard -PassThru -Recurse -Force
    Rename-Item -NewName $finalFolderName -Path D:\inetpub\wwwroot\MyWindDashboardBackup\MyWindDashboard -Force

}