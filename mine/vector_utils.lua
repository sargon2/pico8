function normalize(x, y, scale)
    -- Normalize the given vector and return x, y.
    -- If scale is given, normalize to that distance, otherwise normalize to 1.
    if x == 0 and y == 0 then
        return 0, 0
    end
    if scale == nil then
        scale = 1
    end
    local dist=sqrt(x*x + y*y)
    return x*scale/dist, y*scale/dist
end
   