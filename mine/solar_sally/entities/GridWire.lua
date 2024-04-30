GridWire = {}

function GridWire.init()
    -- Attr_WalkingObstruction[Entities_GridWire] = true
    Attr_pluggable[Entities_GridWire] = true
    Sprites_add(Entities_GridWire, Sprite_id_grid_wire)

    for i=-100,100 do
        Locations_place_entity(Entities_GridWire, i, 10)
    end
end