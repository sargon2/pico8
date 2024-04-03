Wire = {
    ent_id = nil,
}

function Wire.init()
    Wire.ent_id = Entities.create_entity()

    Attributes.set_attrs(Wire.ent_id,
        {
            removable = true,
            placement_sprite = "place_wire",
        }
    )
    Drawable.add_tile_draw_fn(ZValues["Wire"], Wire.ent_id, Wire.draw_wire_tile)
end

function Wire.wire_at(x, y)
    local e = Locations.entity_at(x, y)
    if e == Wire.ent_id then
        return true
    end
    if e == GridWire.ent_id then -- Wire connects to GridWire
        return true
    end
end

function Wire.draw_wire_tile(x, y)
    local left = Wire.wire_at(x-1,y)
    local right = Wire.wire_at(x+1,y)
    local up = Wire.wire_at(x,y-1)
    local down = Wire.wire_at(x,y+1)

    -- straight has a couple of special cases (0 or 1 connections)
    if not up and not down then
        Sprites.draw_spr("wire_left", x, y)
        Sprites.draw_spr("wire_right", x, y)
        return
    end
    if not left and not right then
        Sprites.draw_spr("wire_up", x, y)
        Sprites.draw_spr("wire_down", x, y)
        return
    end

    -- the other cases are all straightforward.  The order here matters for wire overlap.
    if up then
        Sprites.draw_spr("wire_up", x, y)
    end
    if left then
        Sprites.draw_spr("wire_left", x, y)
    end
    if right then
        Sprites.draw_spr("wire_right", x, y)
    end
    if down then
        Sprites.draw_spr("wire_down", x, y)
    end
end
