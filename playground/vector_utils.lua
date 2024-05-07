function dist(x1, y1, x2, y2)
    return xydist(x2-x1,y2-y1)
end

function xydist(a, b)
    return sqrt(a*a + b*b)
end

function normalize(x, y, scale)
    -- Normalize the given vector and return x, y.
    -- If scale is given, normalize to that distance, otherwise normalize to 1.
    if x == 0 and y == 0 then
        return 0, 0
    end
    if scale == nil then
        scale = 1
    end
    local ndist=xydist(x, y)
    return x*scale/ndist, y*scale/ndist
end
