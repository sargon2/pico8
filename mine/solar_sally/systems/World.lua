World = {}

function World.get_name()
    return "World"
end

function World.draw()
    local xmin = flr(Character.x - 10)
    local xmax = flr(Character.x + 8)
    local ymin = flr(Character.y - 9)
    local ymax = flr(Character.y + 9)

    -- TODO
    -- 1. Create a new SmoothLocations to track non-integer stuff (it can't have entity_at() like Locations has so they're separate)
    -- 2. Get all visible SmoothLocation entities
    -- 3. Sort them by y
    -- 4. Render them at the appropriate time in the loop below
    -- 4. Update Character to use SmoothLocations instead of storing its own x/y
    -- 5. Update cow to use SmoothLocations
    -- 6. Evaluate if we can speed up SmoothLocations by storing things sorted and doing binary searches or whatever

    for y = ymin, ymax do
        for x = xmin, xmax do
            local ent_id = Locations.entity_at(x, y)
            if ent_id then
                TileDrawFns.drawTileAt(ent_id, x, y)
            end
        end
        if y == flr(Character.y+.4) then
            Character.drawChar()
        end
    end
end