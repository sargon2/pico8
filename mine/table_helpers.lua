-- TODO this file shouldn't exist and shouldn't be called "helpers"

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
