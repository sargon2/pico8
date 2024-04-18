Sprites = {}

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

function Sprites.add(ent_id, sprite, width, height, yoffset)
    -- Sprite just forwards to DrawFns

    if(not width) width = 1
    if(not height) height = 1
    if(not yoffset) yoffset = 0

    local function d(x, y)
        Sprites.draw_spr(sprite, x, y + yoffset, width, height)
    end

    DrawFns.add(ent_id, d)
end

function round_to_nearest_pixel(num)
    return flr(num * 8) / 8
end

function Sprites.draw_relative_to_screen(s,x,y,width,height,flip_x) -- convenience
    Sprites.draw_spr(s,x,y,width,height,flip_x,true)
end

function Sprites.draw_spr(s, x, y, width, height, flip_x, relative_to_screen)
    if not relative_to_screen then
        x, y = Sprites.convert_map_to_screen(x, y)
    end

    -- Round location to the nearest pixel to prevent vibration when the player is moving
    x = round_to_nearest_pixel(x)
    y = round_to_nearest_pixel(y)

    if(not width) width = 1
    if(not height) height = 1
    -- s = Sprites[s]
    local changed_transparency = false
    if fget(s, 0) then
        -- flag 0 means "use purple as transparent"
        palt(0b0010000000000000) -- purple
        changed_transparency = true
    elseif fget(s, 1) then
        -- flag 1 means "use white as transparent"
        palt(0b0000000100000000)
        changed_transparency = true
    end
    spr(
        s,
        x*8,
        y*8,
        width,
        height,
        flip_x
    )
    if changed_transparency then
        palt()
    end
end

function Sprites.convert_map_to_screen(x, y)
    local char_x, char_y = SmoothLocations.get_location(Character.ent_id)
    return 8+x-char_x, 8+y-char_y
end

function Sprites.set_pixel(x,y,xoffset,yoffset,c, relative_to_screen) -- TODO where should this live?
    if not relative_to_screen then
        x, y = Sprites.convert_map_to_screen(x, y)
    end
    pset(
        x*8+xoffset,
        y*8+yoffset,
        c
    )
end

function Sprites.set_pixel_relative_to_screen(x,y,xoffset,yoffset,c) -- convenience -- TODO where should this live?
    Sprites.set_pixel(x, y, xoffset, yoffset, c, true)
end

function Sprites.rect(x,y,xmin,ymin,xmax,ymax,c) -- TODO where should this live?
    local char_x, char_y = SmoothLocations.get_location(Character.ent_id)
    rect(
        (8+x-char_x)*8+xmin,
        (8+y-char_y)*8+ymin,
        (8+x-char_x)*8+xmax,
        (8+y-char_y)*8+ymax,
        c
    )
end