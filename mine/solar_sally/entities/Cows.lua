Cows = {
    cow_ent_ids = {},
}

function Cows.init()

    for i=1,100 do
        local ent_id = Entities.create_entity()
        add(Cows.cow_ent_ids, ent_id)
        TileDrawFns.add(ent_id, Cows.draw_cow)
        local x = flr(rnd(100))-50
        local y = flr(rnd(100))-50
        SmoothLocations.set_or_update_location(ent_id, x, y)
    end
end

function Cows.draw_cow(x, y)
    local sprite = Sprite_ids["cow_looking"]
    Sprites.draw_spr(sprite, x, y)
end

function Cows.update(elapsed)
    -- For each cow,
    for ent_id in all(Cows.cow_ent_ids) do
        local cow_x, cow_y = SmoothLocations.get_location(ent_id)
        -- TODO choose a movement vector
        SmoothLocations.move_x_by(ent_id, 0.01)
        SmoothLocations.move_y_by(ent_id, 0.01)
    end
end