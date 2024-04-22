SmoothLocations_xs = {} -- xs[ent_id] = x
SmoothLocations_ys = {} -- ys[ent_id] = y

-- SmoothLocations only supports one x/y pair per ent_id.
function SmoothLocations_set_or_update_location(ent_id, x, y)
    SmoothLocations_xs[ent_id] = x
    SmoothLocations_ys[ent_id] = y
end

function SmoothLocations_get_location(ent_id)
    return SmoothLocations_xs[ent_id], SmoothLocations_ys[ent_id]
end

function SmoothLocations_is_obstructed(x, y)
    -- Returns if a smooth entity is obstructing the given coordinates
    for ent_id, ent_x in pairs(SmoothLocations_xs) do

        -- Not sure what's up with these weird values.
        -- The goal of the values is if Sally places a panel, then walks up to it, she can remove and place it again.
        -- But if she picks it up and moves 1 pixel closer, she can't replace it.
        -- TODO this could use a unit test.
        if abs(x-.08-ent_x) <= .49 then
            local ent_y = SmoothLocations_ys[ent_id]
            if abs(y-.55-ent_y) <= .49 then
                return true
            end
        end
    end
    return false
end

function SmoothLocations_move_by_if_not_obstructed(ent_id, x, y, dist)
    x, y = normalize(x, y, dist)
    local old_x = SmoothLocations_xs[ent_id]
    local old_y = SmoothLocations_ys[ent_id]
    local new_x = old_x + x
    local new_y = old_y + y

    -- We have to move x and y separately to allow sliding along an obstruction
    if not World.is_obstructed(new_x, old_y) then
        SmoothLocations_xs[ent_id] = new_x
        old_x = new_x
    end
    if not World.is_obstructed(old_x, new_y) then
        SmoothLocations_ys[ent_id] = new_y
    end
end

function SmoothLocations_get_all_visible(xmin, xmax, ymin, ymax)
    -- ret = {{ent_id, x, y}, {ent_id2, x2, y2}, ...}
    local ret = {}
    for ent_id, x in pairs(SmoothLocations_xs) do
        if xmin <= x and x <= xmax then
            local y = SmoothLocations_ys[ent_id]
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