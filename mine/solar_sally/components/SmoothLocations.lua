SmoothLocations = {
    xs = {}, -- xs[ent_id] = x
    ys = {}, -- ys[ent_id] = y
}

-- SmoothLocations only supports one x/y pair per ent_id.
function SmoothLocations.set_or_update_location(ent_id, x, y)
    SmoothLocations.xs[ent_id] = x
    SmoothLocations.ys[ent_id] = y
end

function SmoothLocations.get_location(ent_id)
    return SmoothLocations.xs[ent_id], SmoothLocations.ys[ent_id]
end

function SmoothLocations.move_y_by(ent_id, y_delta)
    SmoothLocations.ys[ent_id] += y_delta
end

function SmoothLocations.move_x_by(ent_id, x_delta)
    SmoothLocations.xs[ent_id] += x_delta
end

function SmoothLocations.get_all_visible(xmin, xmax, ymin, ymax)
    -- ret = {{ent_id, x, y}, {ent_id2, x2, y2}, ...}
    local ret = {}
    for ent_id, x in pairs(SmoothLocations.xs) do
        if xmin <= x and x <= xmax then
            local y = SmoothLocations.ys[ent_id]
            if ymin <= y and y <= ymax then
                local to_add = {}
                to_add[1] = ent_id
                to_add[2] = x
                to_add[3] = y
                add(ret, to_add)
            end
        end
    end
    return ret
end