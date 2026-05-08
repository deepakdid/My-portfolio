$points = @()
for ($i=0; $i -lt 18; $i++) {
    $angle = $i * [math]::PI / 9 - [math]::PI / 2
    $r = if ($i % 2 -eq 0) { 48 } else { 38 }
    $x = 50 + $r * [math]::Cos($angle)
    $y = 50 + $r * [math]::Sin($angle)
    $points += ,@($x, $y)
}

$path = @()
$n = 18
for ($i=0; $i -lt $n; $i++) {
    $p_prev = $points[($i - 1 + $n) % $n]
    $p_curr = $points[$i]
    $p_next = $points[($i + 1) % $n]

    $v1 = @($p_prev[0] - $p_curr[0], $p_prev[1] - $p_curr[1])
    $v2 = @($p_next[0] - $p_curr[0], $p_next[1] - $p_curr[1])
    
    $len1 = [math]::Sqrt($v1[0]*$v1[0] + $v1[1]*$v1[1])
    $len2 = [math]::Sqrt($v2[0]*$v2[0] + $v2[1]*$v2[1])

    $n1 = @($v1[0]/$len1, $v1[1]/$len1)
    $n2 = @($v2[0]/$len2, $v2[1]/$len2)
    
    $dot = $n1[0]*$n2[0] + $n1[1]*$n2[1]
    $dot = [math]::Max(-1.0, [math]::Min(1.0, $dot))
    $angle = [math]::Acos($dot)
    
    $d = 4 / [math]::Tan($angle / 2) # 4px corner radius
    $d = [math]::Min($d, [math]::Min($len1 / 2.1, $len2 / 2.1))
    
    $t1 = @($p_curr[0] + $n1[0]*$d, $p_curr[1] + $n1[1]*$d)
    $t2 = @($p_curr[0] + $n2[0]*$d, $p_curr[1] + $n2[1]*$d)
    
    if ($i -eq 0) {
        $path += 'M ' + [math]::Round($t1[0], 2) + ' ' + [math]::Round($t1[1], 2)
    } else {
        $path += 'L ' + [math]::Round($t1[0], 2) + ' ' + [math]::Round($t1[1], 2)
    }
        
    $path += 'Q ' + [math]::Round($p_curr[0], 2) + ' ' + [math]::Round($p_curr[1], 2) + ', ' + [math]::Round($t2[0], 2) + ' ' + [math]::Round($t2[1], 2)
}
$path += 'Z'
Write-Output ($path -join ' ')
