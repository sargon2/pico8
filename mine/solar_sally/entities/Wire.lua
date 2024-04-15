Wire = {
    ent_id = nil,
}

function Wire.init()
    Wire.ent_id = Entities.create_entity()

    Attributes.set_attrs(Wire.ent_id,
        {
            removable = true,
            placement_sprite = "place_wire",
            pluggable = true,
        }
    )
    DrawFns.add(Wire.ent_id, Wire.draw_wire_tile)
end

function Wire.is_pluggable(x, y)
    return Attributes.get_attr_by_location(x, y, "pluggable")
end

function Wire.draw_wire_tile(x, y, ent_id, relative_to_screen)
    if relative_to_screen then
        -- For icons and such, we just draw it horizontal.
        Sprites.draw_spr(Sprite_ids["wire_left"], x, y, 1, 1, false, true)
        Sprites.draw_spr(Sprite_ids["wire_right"], x, y, 1, 1, false, true)
        return
    end
    local left = Wire.is_pluggable(x-1,y)
    local right = Wire.is_pluggable(x+1,y)
    local up = Wire.is_pluggable(x,y-1)
    local down = Wire.is_pluggable(x,y+1)

    -- straight has a couple of special cases (0 or 1 connections)
    if not up and not down then
        Sprites.draw_spr(Sprite_ids["wire_left"], x, y)
        Sprites.draw_spr(Sprite_ids["wire_right"], x, y)
        return
    end
    if not left and not right then
        Sprites.draw_spr(Sprite_ids["wire_up"], x, y)
        Sprites.draw_spr(Sprite_ids["wire_down"], x, y)
        return
    end

    -- the other cases are all straightforward.  The order here matters for wire overlap.
    if up then
        Sprites.draw_spr(Sprite_ids["wire_up"], x, y)
    end
    if left then
        Sprites.draw_spr(Sprite_ids["wire_left"], x, y)
    end
    if right then
        Sprites.draw_spr(Sprite_ids["wire_right"], x, y)
    end
    if down then
        Sprites.draw_spr(Sprite_ids["wire_down"], x, y)
    end
end
