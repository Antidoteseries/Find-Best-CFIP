$IP = Read-Host Please inupt IP
if (-not $IP) {
    $IP = 1.0.0.1
}

curl.exe --resolve apple.freecdn.workers.dev:443:$IP https://apple.freecdn.workers.dev/105/media/us/iphone-11-pro/2019/3bd902e4-0752-4ac1-95f8-6225c32aec6d/films/product/iphone-11-pro-product-tpl-cc-us-2019_1280x720h.mp4 -o nul --connect-timeout 5