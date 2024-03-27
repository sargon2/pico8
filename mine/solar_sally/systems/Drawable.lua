Drawable = {
    drawable_data = {}, -- drawable_data[z][type] = data
}

function Drawable.add_aggregate_draw_fn(z, aggregate_draw_fn)
    if not Drawable.drawable_data[z] then
        Drawable.drawable_data[z] = {}
    end
    Drawable.drawable_data[z]["aggregate"] = aggregate_draw_fn
end

function Drawable.add_tile_draw_fn(z, entity_id, tile_draw_fn)
    if not Drawable.drawable_data[z] then
        Drawable.drawable_data[z] = {}
    end
    if not Drawable.drawable_data[z]["tile_draw_fn"] then
        Drawable.drawable_data[z]["tile_draw_fn"] = {}
    end
    Drawable.drawable_data[z]["tile_draw_fn"][entity_id] = tile_draw_fn
end

function Drawable.add_tile_sprite(z, entity_id, sprite)
    if not Drawable.drawable_data[z] then
        Drawable.drawable_data[z] = {}
    end
    if not Drawable.drawable_data[z]["tile_sprite"] then
        Drawable.drawable_data[z]["tile_sprite"] = {}
    end
    Drawable.drawable_data[z]["tile_sprite"][entity_id] = sprite
end

function Drawable.draw()
    Drawable.draw_all(Character.x, Character.y)
end

function Drawable.draw_all(char_x, char_y)
    for z, typedata in pairs(Drawable.drawable_data) do
        for type, data in pairs(typedata) do
            if type == "tile_sprite" then
                for ent_id, sprite in pairs(data) do
                    Drawable.draw_entity(
                        ent_id, 
                        function (x, y)
                            Sprites.draw_spr(sprite, x, y)
                        end,
                        char_x, char_y)
                end
            elseif type == "tile_draw_fn" then
                for ent_id, fn in pairs(data) do
                    Drawable.draw_entity(ent_id, fn, char_x, char_y)
                end
            elseif type == "aggregate" then
                data(char_x, char_y)
            end
        end
    end
end

function Drawable.draw_entity(ent_id, draw_fn, char_x, char_y)
    local locations = Locations.getVisibleLocationsOfEntity(ent_id, char_x, char_y)

    for x, ys in pairs(locations) do
        for y in all(ys) do
            draw_fn(x, y)
        end
    end
end
