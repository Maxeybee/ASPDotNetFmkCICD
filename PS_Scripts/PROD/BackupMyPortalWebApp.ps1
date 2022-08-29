Invoke-Command -ComputerName $env:COMPUTERNAME -ScriptBlock {
    $bitness = ([System.IntPtr]::size * 8) 
    Write-Output "PowerShell is $bitness-bit"
    
    [string]$today = (Get-Date -Format "MM_dd_yyyy_HH_mm")
    [string]$folder = "MYPortal_"
    [string]$finalFolderName = $folder+$today
    
    Copy-Item -Path D:\inetpub\MyWindDashboard\MyWindDashboard -Destination C:\Users\212456430\Desktop\Backup\MyWindDashboard -PassThru -Recurse -Force
    Rename-Item -NewName $finalFolderName -Path C:\Users\212456430\Desktop\Backup\MyWindDashboard -Force

}