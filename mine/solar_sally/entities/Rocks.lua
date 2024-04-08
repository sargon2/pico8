Rocks = {
    ent_id = nil
}

function Rocks.init()
    Rocks.ent_id = Entities.create_entity()
    Attributes.set_attr(Rocks.ent_id, "WalkingObstruction", true)
    Sprites.add(Rocks.ent_id, "rock")

    for _=1,500 do
        local x = flr(rnd(100))-50
        local y = flr(rnd(100))-50
        Locations.place_entity(Rocks.ent_id, x, y)
    end
end