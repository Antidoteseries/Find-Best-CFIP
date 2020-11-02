# Original Script:fping-msys2.0
# Rewrite by PowerShell
$PingInterval = 0
$PingNum = 100
$TestSleep = 2
$TestMaximumTime = 15
$host.UI.RawUI.WindowTitle = "Finding Best CloudFlare IP"
try {
    Write-Host Generating IP List
    New-Item .\temp -ItemType Directory -Force | Out-Null
    foreach ( $IP in Get-Content .\bin\IPList.txt ) {
        $IPRandom = Get-Random -Maximum 255
        Out-File -Encoding UTF8 -FilePath .\temp\IP.txt -InputObject ( $IP + $IPRandom ) -Append
    }
    Write-Host Ping IP
    .\bin\fping.exe -f .\temp\ip.txt -c $PingNum --interval=$PingInterval -s | Out-File -Encoding UTF8 .\temp\ping.csv
    $PingResult = Import-Csv -Encoding UTF8 .\temp\ping.csv | Sort-Object -Property { [int]($_.loss.Replace("%", "")) } | Select-Object -First 200 | Sort-Object -Property { [double]($_.avg.Replace("ms", "")) }  | Select-Object -First 100 -Property address
    Clear-Host
    Write-Host Testing IP...
    New-Item .\temp\speed -ItemType Directory -Force | Out-Null
    foreach ( $TestIP in $PingResult ) {
        $TestIPAddress = $TestIP.address
        Write-Host Testing $TestIPAddress
        Start-Process -FilePath curl.exe -ArgumentList "--resolve speed.cloudflare.com:443:$TestIPAddress https://speed.cloudflare.com/__down?bytes=1000000000", "-o temp/speed/$TestIPAddress", "-s --connect-timeout 2", "--max-time $TestMaximumTime" -WindowStyle Hidden
        Start-Sleep $TestSleep
    }
    Start-Sleep $TestMaximumTime
    $BestIP = Get-ChildItem ./temp/speed | Sort-Object -Property Length -Descending | Select-Object -Property Name -First 5
    Clear-Host
    Write-Host Best IP:
    $ResultName = (Get-Date -Format "yyyy-MM-dd_HH-mm-ss") + ".txt"
    foreach ( $IPName in $BestIP ) {
        if ( -not ( Test-Path ./result )) {
            New-Item .\result -ItemType Directory | Out-Null
        }
        Write-Host $IPName.Name
        Out-File -FilePath .\result\$ResultName -InputObject $IPName.Name -Append
    }
}
catch {
    Write-Host Error
}
finally {
    cmd /c "pause"
    Remove-Item .\temp -Recurse 
}