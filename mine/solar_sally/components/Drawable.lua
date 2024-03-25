Drawable = {
    aggregate_draw_fns = {},
    tile_draw_fns = {},
    tile_sprites = {}
}

function Drawable.add_aggregate_draw_fn(aggregate_draw_fn)
    add(Drawable.aggregate_draw_fns, aggregate_draw_fn)
end

function Drawable.add_tile_draw_fn(entity_id, tile_draw_fn)
    Drawable.tile_draw_fns[entity_id] = tile_draw_fn
end

function Drawable.add_tile_sprite(entity_id, sprite)
    Drawable.tile_sprites[entity_id] = sprite
end

function Drawable.draw_all(char_x, char_y)
    for ent_id, sprite in pairs(Drawable.tile_sprites) do
        Drawable.draw_entity(
            ent_id, 
            function (x, y)
                Sprites.draw_spr(sprite, x, y)
            end,
            char_x, char_y)
    end

    for ent_id, fn in pairs(Drawable.tile_draw_fns) do
        Drawable.draw_entity(ent_id, fn, char_x, char_y)
    end

    for fn in all(Drawable.aggregate_draw_fns) do
        fn(char_x, char_y)
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
