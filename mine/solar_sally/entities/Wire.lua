Wire = {
    ent_id = nil,
}

function Wire.init()
    Wire.ent_id = Entities.create_entity()

    Attributes_set_attr(Wire.ent_id, Attr_removable)
    Attributes_set_attr(Wire.ent_id, Attr_pluggable)
    Attributes_set_attr(Wire.ent_id, Attr_placement_sprite, Sprite_id_place_wire)
    Attributes_set_attr(Wire.ent_id, Attr_DrawFn, Wire.draw_wire_tile)
end


function Wire.draw_wire_tile(x, y, ent_id, relative_to_screen)
    local function is_pluggable(x, y)
        return Attributes_get_attr_by_location(x, y, Attr_pluggable)
    end

    if relative_to_screen then
        -- For icons and such, we just draw it horizontal.
        Sprites.draw_spr(Sprite_id_wire_left, x, y, 1, 1, false, true)
        Sprites.draw_spr(Sprite_id_wire_right, x, y, 1, 1, false, true)
        return
    end
    local left = is_pluggable(x-1,y)
    local right = is_pluggable(x+1,y)
    local up = is_pluggable(x,y-1)
    local down = is_pluggable(x,y+1)

    -- straight has a couple of special cases (0 or 1 connections)
    if not up and not down then
        Sprites.draw_spr(Sprite_id_wire_left, x, y)
        Sprites.draw_spr(Sprite_id_wire_right, x, y)
        return
    end
    if not left and not right then
        Sprites.draw_spr(Sprite_id_wire_up, x, y)
        Sprites.draw_spr(Sprite_id_wire_down, x, y)
        return
    end

    -- the other cases are all straightforward.  The order here matters for wire overlap.
    if up then
        Sprites.draw_spr(Sprite_id_wire_up, x, y)
    end
    if left then
        Sprites.draw_spr(Sprite_id_wire_left, x, y)
    end
    if right then
        Sprites.draw_spr(Sprite_id_wire_right, x, y)
    end
    if down then
        Sprites.draw_spr(Sprite_id_wire_down, x, y)
    end
end
