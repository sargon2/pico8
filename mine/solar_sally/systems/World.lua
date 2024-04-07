World = {}

function World.get_name()
    return "World"
end

function World.draw()
    local char_x, char_y = SmoothLocations.get_location(Character.ent_id)

    local xmin = flr(char_x - 10)
    local xmax = flr(char_x + 8)
    local ymin = flr(char_y - 9)
    local ymax = flr(char_y + 9)

    -- TODO
    -- 1. (done) Create a new SmoothLocations to track non-integer stuff (it can't have entity_at() like Locations has so they're separate)
    -- 2. (done) Get all visible SmoothLocation entities
    local smooth_ents = SmoothLocations.get_all_visible(xmin, xmax, ymin, ymax)
    -- 3. (done) Sort them by y
    World._sort_by_y(smooth_ents)
    -- 4. (done) Render them at the appropriate time in the loop below
    -- 4. (done) Update Character to use SmoothLocations instead of storing its own x/y
    -- 5. Update cow to use SmoothLocations
    -- 6. Evaluate if we can speed up SmoothLocations by storing things sorted and doing binary searches or whatever

    local curr_pos = 1
    for y = ymin, ymax do
        for x = xmin, xmax do
            local ent_id = Locations.entity_at(x, y)
            if ent_id then
                TileDrawFns.drawTileAt(ent_id, x, y)
            end
        end
        if y == flr(char_y+.4) then
            Character.drawChar()
        end
        if next(smooth_ents) then -- TODO is this needed once character is using smooth ents?
            while smooth_ents[curr_pos] and y >= flr(smooth_ents[curr_pos][3]+.4) do
                TileDrawFns.drawTileAt(smooth_ents[curr_pos][1], smooth_ents[curr_pos][2], smooth_ents[curr_pos][3]) -- TODO if we're using it this way it's no longer a "tile draw fn"
                curr_pos += 1
            end
        end
    end
end

function World._sort_by_y(smooth_ents)
    function compare_by_y(a, b)
        return a[3] < b[3]
    end

    quicksort(smooth_ents, compare_by_y)
end
