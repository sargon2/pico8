Map = {
    ent_id = nil,
}

function Map.init()
    Map.ent_id = Entities.create_entity()
    Drawable.add_aggregate_draw_fn(ZValues["Map"], Map.ent_id, Map.drawMap)
end

function Map.get_name()
    return "Map"
end

function Map.drawMap()
    -- The pico8 map only contains grass, and only in the top left 17x17 square.
    -- We only need to draw the map around the player's current position, nowhere else.
    map(0,0,(flr(Character.x) - Character.x)*8,(flr(Character.y) - Character.y)*8, 17, 17)
end