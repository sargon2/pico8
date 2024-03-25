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
        return tostring(o)
    end
end

function table_with_default_val_inserted(default) -- TODO name
    -- TODO this is filling the table with empty tables on every get that returns nil
    local ret = {}
    local mt = {
        __index = function(t, k)
            local val = {}
            t[k] = val -- Insert the default value into the table
            return val
        end
    }
    setmetatable(ret, mt)
    return ret
end
