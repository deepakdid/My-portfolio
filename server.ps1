$port = 8080
$root = $PSScriptRoot
if (-not $root) { $root = (Get-Location).Path }

$mime = @{
    ".html" = "text/html; charset=utf-8"
    ".htm"  = "text/html; charset=utf-8"
    ".css"  = "text/css; charset=utf-8"
    ".js"   = "application/javascript; charset=utf-8"
    ".json" = "application/json; charset=utf-8"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".gif"  = "image/gif"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
    ".webp" = "image/webp"
    ".ttf"  = "font/ttf"
    ".otf"  = "font/otf"
    ".woff" = "font/woff"
    ".woff2"= "font/woff2"
    ".txt"  = "text/plain; charset=utf-8"
    ".pdf"  = "application/pdf"
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://127.0.0.1:$port/")
$listener.Prefixes.Add("http://localhost:$port/")

try {
    $listener.Start()
} catch {
    Write-Host "Failed to start listener: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Press Enter to exit..."
    [void][System.Console]::ReadLine()
    exit 1
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Portfolio server running" -ForegroundColor Green
Write-Host "  Root:  $root"
Write-Host "  URL:   http://localhost:$port/" -ForegroundColor Yellow
Write-Host "  Stop:  Ctrl+C or close this window" -ForegroundColor DarkGray
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

try {
    while ($listener.IsListening) {
        $context = $null
        try {
            $context = $listener.GetContext()
        } catch {
            Write-Host "GetContext error: $($_.Exception.Message)" -ForegroundColor Red
            continue
        }

        $request  = $context.Request
        $response = $context.Response

        try {
            $rawPath = [System.Uri]::UnescapeDataString($request.Url.LocalPath)
            if ([string]::IsNullOrEmpty($rawPath)) { $rawPath = "/" }
            $relPath = $rawPath.TrimStart("/").Replace("/", "\")
            $localFilePath = Join-Path -Path $root -ChildPath $relPath

            $item = Get-Item -LiteralPath $localFilePath -ErrorAction SilentlyContinue
            if ($item -and $item.PSIsContainer) {
                $localFilePath = Join-Path -Path $localFilePath -ChildPath "index.html"
            }

            if (Test-Path -LiteralPath $localFilePath -PathType Leaf) {
                $buffer = [System.IO.File]::ReadAllBytes($localFilePath)
                $ext = [System.IO.Path]::GetExtension($localFilePath).ToLower()
                if ($mime.ContainsKey($ext)) {
                    $response.ContentType = $mime[$ext]
                } else {
                    $response.ContentType = "application/octet-stream"
                }
                $response.ContentLength64 = $buffer.Length
                $response.StatusCode = 200
                if ($request.HttpMethod -ne "HEAD") {
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                }
                Write-Host ("200 {0} {1}" -f $request.HttpMethod, $rawPath) -ForegroundColor DarkGreen
            } else {
                $response.StatusCode = 404
                $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found: $rawPath")
                $response.ContentType = "text/plain; charset=utf-8"
                $response.ContentLength64 = $msg.Length
                $response.OutputStream.Write($msg, 0, $msg.Length)
                Write-Host ("404 {0} {1}" -f $request.HttpMethod, $rawPath) -ForegroundColor DarkYellow
            }
        } catch {
            $errMsg = "500 ERROR: $($_.Exception.Message)`n$($_.ScriptStackTrace)"
            Write-Host $errMsg -ForegroundColor Red
            try {
                $response.StatusCode = 500
                $response.ContentType = "text/plain; charset=utf-8"
                $errBytes = [System.Text.Encoding]::UTF8.GetBytes($errMsg)
                $response.ContentLength64 = $errBytes.Length
                $response.OutputStream.Write($errBytes, 0, $errBytes.Length)
            } catch {}
        } finally {
            try { $response.OutputStream.Close() } catch {}
            try { $response.Close() } catch {}
        }
    }
} finally {
    try { $listener.Stop() } catch {}
    try { $listener.Close() } catch {}
}
