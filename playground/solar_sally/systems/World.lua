World = {
    name = "World",
}

function _draw_map(char_x, char_y)
    -- The pico8 map only contains grass, and only in the top left 17x17 square.
    -- We only need to draw the map around the player's current position, nowhere else.
    map(0,0,(flr(char_x) - char_x)*8,(flr(char_y) - char_y)*8, 17, 17)

    -- Draw all the grass manually.  This is a bit slower but frees up the map memory space.
    -- local offset_x = flr(char_x) - char_x
    -- local offset_y = flr(char_y) - char_y
    -- for x=0,16 do
    --     for y=0,16 do
    --         spr(Sprite_id_grass, (x+offset_x)*8, (y+offset_y)*8)
    --     end
    -- end
end

function World.draw()
    local char_x, char_y = SmoothLocations_get_location(Entities_Character)
    _draw_map(char_x, char_y)

    local xmin, xmax, ymin, ymax = flr(char_x - 10), flr(char_x + 9), flr(char_y - 9), flr(char_y + 9)

    local smooth_ents = SmoothLocations_get_all_visible(xmin, xmax, ymin, ymax)
    World__sort_by_y(smooth_ents)

    -- Draw entities
    local curr_pos = 1
    for y = ymin, ymax do
        local row = Locations_get_row(y)
        for x = xmin, xmax do
            local ent_id = row[x] -- Locations_entity_at(x, y)
            if ent_id then
                Attr_DrawFn[ent_id](x, y, ent_id)
            end
        end
        -- Character is a smooth ent so we always assume there's at least one
        while smooth_ents[curr_pos] and y >= flr(smooth_ents[curr_pos][3]+.4) do
            local ent_id = smooth_ents[curr_pos][1]
            Attr_DrawFn[ent_id](smooth_ents[curr_pos][2], smooth_ents[curr_pos][3], ent_id)
            curr_pos += 1
        end
    end

    -- Check for smooth entity collisions.  TODO extract & move this to SmoothLocations or wherever
    curr_pos = 1
    while smooth_ents[curr_pos+1] do
        local _ent1, x1, y1 = unpack(smooth_ents[curr_pos]) -- TODO refer by number instead of unpacking to save tokens
        local _ent2, x2, y2 = unpack(smooth_ents[curr_pos+1])
        if abs(x1-x2) < 1 and abs(y1-y2) < 1 then
            -- Collision detected
        end
        curr_pos += 1
    end

end

function World__sort_by_y(smooth_ents)
    local function compare_by_y(a, b)
        return a[3] < b[3]
    end

    quicksort(smooth_ents, compare_by_y)
end

function World_is_obstructed(x, y)
    return Attributes_get_attr_by_location(flr(x+.6), flr(y+1), Attr_WalkingObstruction)
end
