Drawable = {
    draw_fns = {}, -- draw_fns[z][ent_id] = fn
    aggregate_draw_fns = {}, -- aggregate_draw_fns[z][ent_id] = fn
}

function Drawable.init()
    -- make sure we have enough room in our z arrays
    for i=1,ZValues.get_max() do
        Drawable.draw_fns[i] = {}
        Drawable.aggregate_draw_fns[i] = {}
    end
end

function Drawable.get_name()
    return "Drawable"
end

function Drawable.add_aggregate_draw_fn(z, ent_id, aggregate_draw_fn)
    Drawable.aggregate_draw_fns[z][ent_id] = aggregate_draw_fn
end

function Drawable.add_tile_draw_fn(z, entity_id, tile_draw_fn)
    Drawable.draw_fns[z][entity_id] = tile_draw_fn
end

function Drawable.add_tile_sprite(z, entity_id, sprite)
    Drawable.add_tile_draw_fn(z, entity_id, function (x, y) Sprites.draw_spr(sprite, x, y) end)
end

function Drawable.draw()
    Drawable.draw_all(Character.x, Character.y)
end

function Drawable.draw_all(char_x, char_y)
    for z=1,ZValues.get_max() do
        -- Location-based draw fns
        for ent_id, fn in pairs(Drawable.draw_fns[z]) do
            Drawable.draw_entity(ent_id, fn, char_x, char_y)
        end

        -- Aggregate draw fns
        for ent_id, fn in pairs(Drawable.aggregate_draw_fns[z]) do
            fn(char_x, char_y)
        end
    end
end

function Drawable.draw_entity(ent_id, draw_fn, char_x, char_y)
    local locations = Locations.getVisibleLocationsOfEntity(ent_id, char_x, char_y) -- TODO this is the slowest call in the game

    for t in locations do
        local x = t[1]
        local y = t[2]
        draw_fn(x, y)
    end
end
