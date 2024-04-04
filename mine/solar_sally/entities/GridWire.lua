GridWire = {
    ent_id = nil,
}

function GridWire.init()
    GridWire.ent_id = Entities.create_entity()
    Attributes.set_attrs(GridWire.ent_id,
        {
            WalkingObstruction = true,
            pluggable = true,
        }
    )
    Drawable.add_tile_sprite(ZValues["GridWire"], GridWire.ent_id, "grid_wire")

    for i=-100,100 do
        Locations.place_entity(GridWire.ent_id, i, 10)
    end
end