Map = {
    name = "Map",
}

-- TODO merge this class into World

function Map.draw()
    local char_x, char_y = SmoothLocations_get_location(Entities_Character) -- TODO pass character location around instead of getting it globally all over the place?
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