-- Things that should be built into Lua but aren't.

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostr(o)
    end
end

function table_with_default_table_inserted() -- TODO name
    -- TODO this is filling the table with empty tables on every get that returns nil
    local ret = {}
    local mt = {
        __index = function(t, k)
            local val = {}
            t[k] = val
            return val
        end
    }
    setmetatable(ret, mt)
    return ret
end

function table_with_default_val(default) -- TODO name
    local ret = {}
    local mt = {
        __index = function(t, k)
            return default
        end
    }
    setmetatable(ret, mt)
    return ret
end

function bound(val, min, max)
    if val < min then
        return min
    elseif val > max then
        return max
    end
    return val
end

function get_only_element(tbl)
    assert(#tbl == 1)
    for x in all(tbl) do
        return x
    end
end

-- Turn the given function (coroutine) into an iterator.  It should call 'yield' to return each value.
function make_iter(f, ...)
    local cor = cocreate(f)
    local args = {...}
    return function ()
        if cor and costatus(cor) != 'dead' then
            local _, val = coresume(cor, unpack(args))
            return val
        else
            return nil
        end
    end
end

-- Be careful using this, it's O(n)
function contains(haystack, needle)
    for val in all(haystack) do
        if val == needle then
            return true
        end
    end
    return false
end
