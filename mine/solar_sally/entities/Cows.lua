Cows = {
    ent_id = nil,
    cow_locations = {}, -- cow_locations[cow_id][x] = y
    cow_looking = {}, -- cow_looking[cow_id] = true
}

function Cows.init()
    Cows.ent_id = Entities.create_entity()
    TileDrawFns.add(Cows.ent_id, Cows.draw_cow)

    for i=1,100 do
        local x = flr(rnd(100))-50
        local y = flr(rnd(100))-50
        Locations.place_entity(Cows.ent_id, x, y)
    end
end

function Cows.draw_cow(x, y)
    local sprite = Sprite_ids["cow_looking"]
    Sprites.draw_spr(sprite, x, y)
end