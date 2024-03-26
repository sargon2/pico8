Wire = {
    ent_id = nil,
}

function Wire.init()
    Wire.ent_id = Entities.create_entity()
    Drawable.add_tile_draw_fn(Wire.ent_id, Wire.draw_wire_tile)
    Attributes.set_attr(Wire.ent_id, "pick_uppable", true)
    Attributes.set_attr(Wire.ent_id, "placement_sprite", "place_wire")
end

function Wire.place_wire_at(x, y)
    Locations.place_entity(Wire.ent_id, x, y)
end

function Wire.wire_at(x, y)
    return Locations.entity_at(x, y) == Wire.ent_id
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
