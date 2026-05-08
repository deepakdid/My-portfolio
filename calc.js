var math = Math;
function createRoundedStar(cx, cy, num_points, outer_r, inner_r, corner_radius) {
    var points = [];
    for (var i = 0; i < num_points * 2; i++) {
        var angle = i * math.PI / num_points - math.PI / 2;
        var r = i % 2 === 0 ? outer_r : inner_r;
        var x = cx + r * math.cos(angle);
        var y = cy + r * math.sin(angle);
        points.push([x, y]);
    }

    var path = [];
    var n = points.length;
    for (var i = 0; i < n; i++) {
        var p_prev = points[(i - 1 + n) % n];
        var p_curr = points[i];
        var p_next = points[(i + 1) % n];

        var v1 = [p_prev[0] - p_curr[0], p_prev[1] - p_curr[1]];
        var v2 = [p_next[0] - p_curr[0], p_next[1] - p_curr[1]];
        
        var len1 = math.sqrt(v1[0]*v1[0] + v1[1]*v1[1]);
        var len2 = math.sqrt(v2[0]*v2[0] + v2[1]*v2[1]);

        var n1 = [v1[0]/len1, v1[1]/len1];
        var n2 = [v2[0]/len2, v2[1]/len2];
        
        var dot = n1[0]*n2[0] + n1[1]*n2[1];
        dot = math.max(-1.0, math.min(1.0, dot));
        var angle = math.acos(dot);
        
        var d = corner_radius / math.tan(angle / 2);
        d = math.min(d, len1 / 2.1, len2 / 2.1);
        
        var t1 = [p_curr[0] + n1[0]*d, p_curr[1] + n1[1]*d];
        var t2 = [p_curr[0] + n2[0]*d, p_curr[1] + n2[1]*d];
        
        var t1x = Math.round(t1[0] * 100) / 100;
        var t1y = Math.round(t1[1] * 100) / 100;
        var p_curr_x = Math.round(p_curr[0] * 100) / 100;
        var p_curr_y = Math.round(p_curr[1] * 100) / 100;
        var t2x = Math.round(t2[0] * 100) / 100;
        var t2y = Math.round(t2[1] * 100) / 100;
        
        if (i === 0) {
            path.push('M ' + t1x + ' ' + t1y);
        } else {
            path.push('L ' + t1x + ' ' + t1y);
        }
            
        path.push('Q ' + p_curr_x + ' ' + p_curr_y + ', ' + t2x + ' ' + t2y);
    }
    path.push('Z');
    return path.join(' ');
}

WScript.Echo(createRoundedStar(50, 50, 9, 48, 38, 6));
