GridWire = {}

function GridWire.init()
    Attributes_set_attr(Entities_GridWire, Attr_WalkingObstruction, true)
    Attributes_set_attr(Entities_GridWire, Attr_pluggable, true)
    Sprites_add(Entities_GridWire, Sprite_id_grid_wire)

    for i=-100,100 do
        Locations_place_entity(Entities_GridWire, i, 10)
    end
end