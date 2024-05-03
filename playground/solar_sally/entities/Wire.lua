Wire = {}

function Wire.init()
    Attr_removable[Entities_Wire] = true
    Attr_pluggable[Entities_Wire] = true
    Attr_placement_sprite[Entities_Wire] = Sprite_id_place_wire
    Attr_DrawFn[Entities_Wire] = Wire.draw_wire_tile
end


function Wire.draw_wire_tile(x, y, ent_id, relative_to_screen)
    local function is_pluggable(x, y)
        return Attributes_get_attr_by_location(x, y, Attr_pluggable)
    end

    if relative_to_screen then
        -- For icons and such, we just draw it horizontal.
        Sprites_draw_spr(Sprite_id_wire_left, x, y, 1, 1, false, true)
        Sprites_draw_spr(Sprite_id_wire_right, x, y, 1, 1, false, true)
        return
    end
    local left = is_pluggable(x-1,y)
    local right = is_pluggable(x+1,y)
    local up = is_pluggable(x,y-1)
    local down = is_pluggable(x,y+1)

    -- straight has a couple of special cases (0 or 1 connections)
    if not up and not down then
        Sprites_draw_spr(Sprite_id_wire_left, x, y)
        Sprites_draw_spr(Sprite_id_wire_right, x, y)
        return
    end
    if not left and not right then
        Sprites_draw_spr(Sprite_id_wire_up, x, y)
        Sprites_draw_spr(Sprite_id_wire_down, x, y)
        return
    end

    -- the other cases are all straightforward.  The order here matters for wire overlap.
    if up then
        Sprites_draw_spr(Sprite_id_wire_up, x, y)
    end
    if left then
        Sprites_draw_spr(Sprite_id_wire_left, x, y)
    end
    if right then
        Sprites_draw_spr(Sprite_id_wire_right, x, y)
    end
    if down then
        Sprites_draw_spr(Sprite_id_wire_down, x, y)
    end
end
