Map = {}

function Map.init()
    Drawable.add_aggregate_draw_fn(ZValues["Map"], Map.drawMap)
end

function Map.drawMap()
    -- The pico8 map only contains grass, and only in the top left 17x17 square.
    -- We only need to draw the map around the player's current position, nowhere else.
    map(0,0,(flr(Character.x) - Character.x)*8,(flr(Character.y) - Character.y)*8, 17, 17)
end