Map = {}

function Map.get_name()
    return "Map"
end

function Map.draw()
    local char_x, char_y = SmoothLocations_get_location(Entities_Character) -- TODO pass character location around instead of getting it globally all over the place?
    -- The pico8 map only contains grass, and only in the top left 17x17 square.
    -- We only need to draw the map around the player's current position, nowhere else.
    map(0,0,(flr(char_x) - char_x)*8,(flr(char_y) - char_y)*8, 17, 17)
end