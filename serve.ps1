$port = 8000
$root = (Get-Location).Path
$prefix = "http://localhost:$port/"

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)
$listener.Start()
Write-Host "Serving $root at $prefix (Ctrl+C to stop)"

$mime = @{
    ".html" = "text/html; charset=utf-8"
    ".htm"  = "text/html; charset=utf-8"
    ".css"  = "text/css; charset=utf-8"
    ".js"   = "application/javascript; charset=utf-8"
    ".json" = "application/json; charset=utf-8"
    ".svg"  = "image/svg+xml"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".gif"  = "image/gif"
    ".webp" = "image/webp"
    ".ico"  = "image/x-icon"
    ".woff" = "font/woff"
    ".woff2"= "font/woff2"
    ".ttf"  = "font/ttf"
    ".mp4"  = "video/mp4"
    ".webm" = "video/webm"
}

try {
    while ($listener.IsListening) {
        $ctx = $listener.GetContext()
        $req = $ctx.Request
        $res = $ctx.Response

        $relPath = [System.Uri]::UnescapeDataString($req.Url.AbsolutePath.TrimStart('/'))
        if ([string]::IsNullOrEmpty($relPath)) { $relPath = "index.html" }

        $fullPath = Join-Path $root $relPath
        if ((Test-Path $fullPath) -and (Get-Item $fullPath).PSIsContainer) {
            $fullPath = Join-Path $fullPath "index.html"
        }

        Write-Host "$($req.HttpMethod) $($req.Url.AbsolutePath) -> $fullPath"

        if (Test-Path $fullPath -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($fullPath).ToLower()
            $type = if ($mime.ContainsKey($ext)) { $mime[$ext] } else { "application/octet-stream" }
            $bytes = [System.IO.File]::ReadAllBytes($fullPath)
            $res.ContentType = $type
            $res.ContentLength64 = $bytes.Length
            $res.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $res.StatusCode = 404
            $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found: $relPath")
            $res.OutputStream.Write($msg, 0, $msg.Length)
        }
        $res.OutputStream.Close()
    }
} finally {
    $listener.Stop()
}
