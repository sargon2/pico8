Rocks = {
    ent_id = nil
}

function Rocks.init()
    Rocks.ent_id = Entities.create_entity()
    Attributes_set_attr(Rocks.ent_id, Attr_WalkingObstruction, true)
    Sprites.add(Rocks.ent_id, Sprite_id_rock)

    for _=1,500 do
        local x = flr(rnd(100))-50
        local y = flr(rnd(100))-50
        if x != 0 or y != 0 then -- Don't want a rock starting right over Sally
            Locations.place_entity(Rocks.ent_id, x, y)
        end
    end
end