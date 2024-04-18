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
                DrawFns.drawTileAt(ent_id, x, y)
            end
        end
        -- Character is a smooth ent so we always assume there's at least one
        while smooth_ents[curr_pos] and y >= flr(smooth_ents[curr_pos][3]+.4) do
            DrawFns.drawTileAt(smooth_ents[curr_pos][1], smooth_ents[curr_pos][2], smooth_ents[curr_pos][3])
            curr_pos += 1
        end
    end

    -- Check for smooth entity collisions.  TODO extract & move this to SmoothLocations or wherever
    curr_pos = 1
    while smooth_ents[curr_pos+1] do
        local ent1, x1, y1 = unpack(smooth_ents[curr_pos]) -- TODO refer by number instead of unpacking to save tokens
        local ent2, x2, y2 = unpack(smooth_ents[curr_pos+1])
        if abs(x1-x2) < 1 and abs(y1-y2) < 1 then
            -- Collision detected
        end
        curr_pos += 1
    end

end

function World._sort_by_y(smooth_ents)
    local function compare_by_y(a, b)
        return a[3] < b[3]
    end

    quicksort(smooth_ents, compare_by_y)
end

function World.is_obstructed(x, y)
    return Attributes.get_attr_by_location(flr(x+.6), flr(y+1), "WalkingObstruction")
end
