--[[const]] SmoothLocations_cell_size = 16
SmoothLocations_Grid = {} -- Grid[cell_x][cell_y][ent_id] = {x, y}
SmoothLocations_cell = {} -- cell[ent_id] = {cell_x, cell_y}

function SmoothLocations__get_cell(x, y)
    return x \ SmoothLocations_cell_size, y \ SmoothLocations_cell_size
end

-- SmoothLocations only supports one x/y pair per ent_id.
function SmoothLocations_set_or_update_location(ent_id, x, y)
    local cell_x, cell_y = SmoothLocations__get_cell(x, y)

    local old_cell = SmoothLocations_cell[ent_id]
    if old_cell then -- if not then it's a new ent_id

        if old_cell[1] != cell_x or old_cell[2] != cell_y then
            SmoothLocations_Grid[old_cell[1]][old_cell[2]][ent_id] = nil
        end
    end

    -- TODO there's gotta be a better way to do this...
    if(not SmoothLocations_Grid[cell_x]) SmoothLocations_Grid[cell_x] = {}
    if(not SmoothLocations_Grid[cell_x][cell_y]) SmoothLocations_Grid[cell_x][cell_y] = {}

    SmoothLocations_Grid[cell_x][cell_y][ent_id] = {x, y}
    SmoothLocations_cell[ent_id] = {cell_x, cell_y}
end

function SmoothLocations_get_location(ent_id)
    local cell = SmoothLocations_cell[ent_id]
    if(not cell) return nil
    local loc = SmoothLocations_Grid[cell[1]][cell[2]][ent_id]
    return loc[1], loc[2]
end

function SmoothLocations_is_obstructed(x, y)
    -- Not sure what's up with these weird values.
    -- The goal of the values is if Sally places a panel, then walks up to it, she can remove and place it again.
    -- But if she picks it up and moves 1 pixel closer, she can't replace it.
    -- TODO this could use a unit test.
    local xmin = (x-.08)-.49
    local xmax = (x-.08)+.49
    local ymin = (y-.55)-.49
    local ymax = (y-.55)+.49

    local results = SmoothLocations_get_all_visible(xmin, xmax, ymin, ymax) -- TODO we only need the first one...
    if next(results) then
        return true
    end
    return false
end

function SmoothLocations_move_by_if_not_obstructed(ent_id, x, y, dist)
    x, y = normalize(x, y, dist)
    local new_x, new_y = SmoothLocations_get_location(ent_id)

    if system_is_loaded(World) then
        -- We have to move x and y separately to allow sliding along an obstruction
        if not World.is_obstructed(new_x + x, new_y) then
            new_x += x
        end
        if not World.is_obstructed(new_x, new_y + y) then
            new_y += y
        end
    else
        new_x += x
        new_y += y
    end
    SmoothLocations_set_or_update_location(ent_id, new_x, new_y)
end

function SmoothLocations_get_all_visible(xmin, xmax, ymin, ymax)

    -- ret = {{ent_id, x, y}, {ent_id2, x2, y2}, ...}
    local ret = {}

    local cellxmin, cellymin = SmoothLocations__get_cell(xmin, ymin)
    local cellxmax, cellymax = SmoothLocations__get_cell(xmax, ymax)

    for cellx = cellxmin, cellxmax do
        for celly = cellymin, cellymax do
            if SmoothLocations_Grid[cellx] and SmoothLocations_Grid[cellx][celly] then
                for ent_id, loc in pairs(SmoothLocations_Grid[cellx][celly]) do
                    if xmin <= loc[1] and loc[1] <= xmax then
                        if ymin <= loc[2] and loc[2] <= ymax then
                            add(ret, {ent_id, loc[1], loc[2]})
                        end
                    end
                end
            end
        end
    end

    return ret
end