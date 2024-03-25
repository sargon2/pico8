Rocks = {  -- Not a component, just a namespace.  Or is it a "system"?
    ent_id = nil
}

function Rocks.draw_one_rock(x, y)
    Sprites.draw_spr("rock", x, y)
end

function Rocks.create_rocks()
    Rocks.ent_id = Entities.create_entity()
    WalkingObstructions.add_entity(Rocks.ent_id)
    ObjectTypes.add_entity(Rocks.ent_id, "rock")
    Drawable.add_entity(Rocks.ent_id, Rocks.draw_one_rock)
    for i=1,1000 do
        local x = flr(rnd(100))
        local y = flr(rnd(100))
        Locations.place_entity(Rocks.ent_id, x, y)
    end
end

function Rocks.draw_rocks(x, y)
    local locations = Locations.getVisibleLocationsOfEntity(Rocks.ent_id, x, y)

    for x, ys in pairs(locations) do
        for y in all(ys) do
            Rocks.draw_one_rock(x, y)
        end
    end
end
