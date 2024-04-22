--[[const]] SmoothLocations_cell_size = 16
SmoothLocations_GridX = {} -- Grid[cell_x][cell_y][ent_id] = x -- TODO would it be faster to have a single array that stores {x, y} rather than 2 arrays?
SmoothLocations_GridY = {} -- Grid[cell_x][cell_y][ent_id] = y
SmoothLocations_cell_x = {} -- cell_x[ent_id] = cell_x -- TODO same here
SmoothLocations_cell_y = {} -- cell_y[ent_id] = cell_y


function SmoothLocations__get_cell(x, y)
    return flr(x / SmoothLocations_cell_size), flr(y / SmoothLocations_cell_size)
end

-- SmoothLocations only supports one x/y pair per ent_id.
function SmoothLocations_set_or_update_location(ent_id, x, y)
    local cell_x, cell_y = SmoothLocations__get_cell(x, y)

    local old_cellx = SmoothLocations_cell_x[ent_id]
    if old_cellx then -- if not then it's a new ent_id
        local old_celly = SmoothLocations_cell_y[ent_id]

        if old_cellx != cell_x or old_celly != cell_y then
            SmoothLocations_GridX[old_cellx][old_celly][ent_id] = nil
            SmoothLocations_GridY[old_cellx][old_celly][ent_id] = nil
        end
    end

    -- TODO there's gotta be a better way to do this...
    if(not SmoothLocations_GridX[cell_x]) SmoothLocations_GridX[cell_x] = {}
    if(not SmoothLocations_GridX[cell_x][cell_y]) SmoothLocations_GridX[cell_x][cell_y] = {}
    if(not SmoothLocations_GridY[cell_x]) SmoothLocations_GridY[cell_x] = {}
    if(not SmoothLocations_GridY[cell_x][cell_y]) SmoothLocations_GridY[cell_x][cell_y] = {}

    SmoothLocations_GridX[cell_x][cell_y][ent_id] = x
    SmoothLocations_GridY[cell_x][cell_y][ent_id] = y
    SmoothLocations_cell_x[ent_id] = cell_x
    SmoothLocations_cell_y[ent_id] = cell_y
end

function SmoothLocations_get_location(ent_id)
    local x = SmoothLocations_cell_x[ent_id]
    if(not x) return nil -- unknown entity
    local y = SmoothLocations_cell_y[ent_id]
    return
        SmoothLocations_GridX[x][y][ent_id],
        SmoothLocations_GridY[x][y][ent_id]
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

    -- We have to move x and y separately to allow sliding along an obstruction
    if not World.is_obstructed(new_x + x, new_y) then
        new_x += x
    end
    if not World.is_obstructed(new_x, new_y + y) then
        new_y += y
    end
    SmoothLocations_set_or_update_location(ent_id, new_x, new_y)
end

function SmoothLocations_get_all_visible(xmin, xmax, ymin, ymax)

    -- ret = {{ent_id, x, y}, {ent_id2, x2, y2}, ...}
    local ret = {}

    cellxmin, cellymin = SmoothLocations__get_cell(xmin, ymin)
    cellxmax, cellymax = SmoothLocations__get_cell(xmax, ymax)

    for cellx = cellxmin, cellxmax do
        for celly = cellymin, cellymax do
            for ent_id, x in pairs(SmoothLocations_GridX[cellx][celly]) do
                if xmin <= x and x <= xmax then
                    local y = SmoothLocations_GridY[cellx][celly][ent_id]
                    if ymin <= y and y <= ymax then
                        local to_add = {ent_id, x, y}
                        add(ret, to_add)
                    end
                end
            end
        end
    end

    return ret
end