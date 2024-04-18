GridWire = {
    ent_id = nil,
}

function GridWire.init()
    GridWire.ent_id = Entities.create_entity()
    Attributes_set_attr(GridWire.ent_id, Attr_WalkingObstruction, true)
    Attributes_set_attr(GridWire.ent_id, Attr_pluggable, true)
    Sprites.add(GridWire.ent_id, Sprite_id_grid_wire)

    for i=-100,100 do
        Locations.place_entity(GridWire.ent_id, i, 10)
    end
end