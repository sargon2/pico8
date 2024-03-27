Rocks = {  -- Not a component, just a namespace.  Or is it a "system"?
    ent_id = nil
}

function Rocks.init()
    Rocks.ent_id = Entities.create_entity()
    Attributes.set_attr(Rocks.ent_id, "WalkingObstruction", true)
    Drawable.add_tile_sprite(ZValues["Rocks"], Rocks.ent_id, "rock") -- todo thing to manage/centralize z orders to ensure no duplicates
    for i=1,1000 do
        local x = flr(rnd(100))
        local y = flr(rnd(100))
        Locations.place_entity(Rocks.ent_id, x, y)
    end
end