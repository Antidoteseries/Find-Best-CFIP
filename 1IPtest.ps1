$IP = Read-Host Please inupt IP
if (-not $IP) {
    $IP = 1.0.0.1
}

curl.exe --resolve speed.cloudflare.com:443:$IP https://speed.cloudflare.com/__down?bytes=1000000000 -o nul --connect-timeout 5