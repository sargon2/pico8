--[[const]] Sprite_id_grass = 16
--[[const]] Sprite_id_solar_panel = 17
--[[const]] Sprite_id_transformer_left = 18
--[[const]] Sprite_id_transformer_right = 19
--[[const]] Sprite_id_cow_side = 22
--[[const]] Sprite_id_cow_looking = 23
--[[const]] Sprite_id_selection_box = 32
--[[const]] Sprite_id_pick_up = 34
--[[const]] Sprite_id_no_action = 35
--[[const]] Sprite_id_place_panel = 33
--[[const]] Sprite_id_place_wire = 36
--[[const]] Sprite_id_young_tree = 38
--[[const]] Sprite_id_place_transformer = 20
--[[const]] Sprite_id_rock = 48
--[[const]] Sprite_id_wire_left = 49
--[[const]] Sprite_id_wire_right = 50
--[[const]] Sprite_id_wire_up = 51
--[[const]] Sprite_id_wire_down = 52
--[[const]] Sprite_id_grid_wire = 54
--[[const]] Sprite_id_tree_top = 21
--[[const]] Sprite_id_tree_bottom = 37
--[[const]] Sprite_id_button = 24
--[[const]] Sprite_id_button_mini = 40
--[[const]] Sprite_id_button_pressed = 25
--[[const]] Sprite_id_window_ul = 13
--[[const]] Sprite_id_window_u = 14
--[[const]] Sprite_id_window_ur = 15
--[[const]] Sprite_id_window_l = 29
--[[const]] Sprite_id_window_m = 30
--[[const]] Sprite_id_window_r = 31
--[[const]] Sprite_id_window_bl = 45
--[[const]] Sprite_id_window_b = 46
--[[const]] Sprite_id_window_br = 47
--[[const]] Sprite_id_money = 55
--[[const]] Sprite_id_axe_swing_right_1 = 11
--[[const]] Sprite_id_axe_swing_right_2 = 12
--[[const]] Sprite_id_place_axe = 28
--[[const]] Sprite_id_inventory_axe = 27
--[[const]] Sprite_id_fence_left = 56
--[[const]] Sprite_id_fence_right = 57
--[[const]] Sprite_id_fence_up = 58
--[[const]] Sprite_id_fence_down = 59
--[[const]] Sprite_id_fence_mini = 43
--[[const]] Sprite_id_inventory_key = 26

--[[const]] Sprite_id_floor_1 = 67
--[[const]] Sprite_id_floor_2 = 68

-- Sprite flag meanings
--[[const]] Sprite_flag_transparent_purple = 0
--[[const]] Sprite_flag_transparent_white = 1
--[[const]] Sprite_flag_has_offset = 2 -- I could just look it up in the offset table, but that's O(n) and getting the flag is O(1)
--[[const]] Sprite_flag_indoor_walking_obstruction = 3
--[[const]] Sprite_flag_indoor_has_floor_behind = 4
--[[const]] Sprite_flag_layer_bit1 = 5 -- "is sometimes in front of character based on y value"
--[[const]] Sprite_flag_layer_bit2 = 6 -- "is always in front of character"
--[[const]] Sprite_flag_exits = 7 -- whether or not stepping on the tile goes outside

Sprites_offsets = {
    [Sprite_id_axe_swing_right_1] = {-2, 0},
    [Sprite_id_axe_swing_right_2] = {2, 0},
}

function Sprites_add(ent_id, sprite, width, height, yoffset)
    -- Sprite just forwards to the DrawFn attribute

    if(not width) width = 1
    if(not height) height = 1
    if(not yoffset) yoffset = 0

    local function d(x, y, eid, relative_to_screen)
        Sprites_draw_spr(sprite, x, y + yoffset, width, height, false, relative_to_screen)
    end

    Attr_DrawFn[ent_id] = d
end

function round_to_nearest_pixel(num)
    return flr(num * 8) / 8
end

function Sprites_draw_relative_to_screen(s,x,y,width,height,flip_x) -- convenience
    Sprites_draw_spr(s,x,y,width,height,flip_x,true)
end

function Sprites_draw_spr(s, x, y, width, height, flip_x, relative_to_screen)
    if not relative_to_screen then
        x, y = Sprites_convert_map_to_screen(x, y)
    end

    -- Round location to the nearest pixel to prevent vibration when the player is moving
    x = round_to_nearest_pixel(x)
    y = round_to_nearest_pixel(y)

    local xoffset, yoffset = 0, 0

    if(not width) width = 1
    if(not height) height = 1
    -- s = Sprites[s]
    local changed_transparency = false
    if fget(s, Sprite_flag_transparent_purple) then
        palt(0b0010000000000000) -- purple
        changed_transparency = true
    elseif fget(s, Sprite_flag_transparent_white) then
        palt(0b0000000100000000)
        changed_transparency = true
    elseif fget(s, Sprite_flag_has_offset) then
        xoffset, yoffset = unpack(Sprites_offsets[s])
        if(flip_x) xoffset = -xoffset
    end
    spr(
        s,
        x*8+xoffset,
        y*8+yoffset,
        width,
        height,
        flip_x
    )
    if changed_transparency then
        palt()
    end
end

function Sprites_draw_line(x1, y1, x2, y2, color, relative_to_screen)
    if not relative_to_screen then
        x1, y1 = Sprites_convert_map_to_screen(x1, y1)
        x2, y2 = Sprites_convert_map_to_screen(x2, y2)
    end
    line(x1*8, y1*8, x2*8, y2*8, color)
end

function Sprites_convert_map_to_screen(x, y)
    local char_x, char_y = SmoothLocations_get_location(Entities_Character)
    return 8+x-char_x, 8+y-char_y
end

function Sprites_set_pixel(x,y,xoffset,yoffset,c, relative_to_screen)
    if not relative_to_screen then
        x, y = Sprites_convert_map_to_screen(x, y)
    end
    pset(
        x*8+xoffset,
        y*8+yoffset,
        c
    )
end

function Sprites_set_pixel_relative_to_screen(x,y,xoffset,yoffset,c) -- convenience
    Sprites_set_pixel(x, y, xoffset, yoffset, c, true)
end

function Sprites_rect(x,y,xmin,ymin,xmax,ymax,c)
    local char_x, char_y = SmoothLocations_get_location(Entities_Character)
    rect(
        (8+x-char_x)*8+xmin,
        (8+y-char_y)*8+ymin,
        (8+x-char_x)*8+xmax,
        (8+y-char_y)*8+ymax,
        c
    )
end

function Sprites_print_text(text, colour, x, y, xoffset, yoffset, relative_to_screen)
    if(colour) color(colour)
    if not relative_to_screen then
        x, y = Sprites_convert_map_to_screen(x, y)
    end
    if(not xoffset) xoffset = 0
    if(not yoffset) yoffset = 0
    print(text, x*8+xoffset, y*8+yoffset)
end

function Sprites_draw_linking(x, y, relative_to_screen, linking_attr, left_spr, right_spr, up_spr, down_spr)
    if relative_to_screen then
        -- For icons and such, we just draw it horizontal.
        Sprites_draw_spr(left_spr, x, y, 1, 1, false, true)
        Sprites_draw_spr(right_spr, x, y, 1, 1, false, true)
        return
    end
    local left = Attributes_get_attr_by_location(x-1,y, linking_attr)
    local right = Attributes_get_attr_by_location(x+1,y, linking_attr)
    local up = Attributes_get_attr_by_location(x,y-1, linking_attr)
    local down = Attributes_get_attr_by_location(x,y+1, linking_attr)

    -- straight has a couple of special cases (0 or 1 connections)
    if not up and not down then
        Sprites_draw_spr(left_spr, x, y)
        Sprites_draw_spr(right_spr, x, y)
        return
    end
    if not left and not right then
        Sprites_draw_spr(up_spr, x, y)
        Sprites_draw_spr(down_spr, x, y)
        return
    end

    -- the other cases are all straightforward.  The order here matters for overlap.
    if up then
        Sprites_draw_spr(up_spr, x, y)
    end
    if left then
        Sprites_draw_spr(left_spr, x, y)
    end
    if right then
        Sprites_draw_spr(right_spr, x, y)
    end
    if down then
        Sprites_draw_spr(down_spr, x, y)
    end
end
