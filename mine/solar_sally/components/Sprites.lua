Sprites = {}

-- TODO is there a clever way I can erase this at build time?
Sprite_ids = {
    solar_panel = 17,
    transformer_left = 18,
    transformer_right = 19,
    cow_side = 22,
    cow_looking = 23,
    selection_box = 32,
    pick_up = 34,
    no_action = 35,
    place_panel = 33,
    place_wire = 36,
    place_transformer = 20,
    rock = 48,
    wire_left = 49,
    wire_right = 50,
    wire_up = 51,
    wire_down = 52,
    grid_wire = 54,
    tree_top = 21,
    tree_bottom = 37,
    button = 24,
    button_mini = 40,
    button_pressed = 25,
    window_ul = 13,
    window_u = 14,
    window_ur = 15,
    window_l = 29,
    window_m = 30,
    window_r = 31,
    window_bl = 45,
    window_b = 46,
    window_br = 47,
}

function Sprites.add(ent_id, sprite, width, height, yoffset)
    -- Sprite just forwards to DrawFns

    sprite = Sprite_ids[sprite]
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

function Sprites.draw_relative_to_screen(s,x,y,width,height,flip_x)
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

function Sprites.draw_spr(s,x,y,width,height,flip_x)
    local char_x, char_y = SmoothLocations.get_location(Character.ent_id)
    Sprites.draw_relative_to_screen(s,8+x-char_x,8+y-char_y,width,height,flip_x)
end

function Sprites.set_pixel(x,y,xoffset,yoffset,c) -- TODO where should this live?
    local char_x, char_y = SmoothLocations.get_location(Character.ent_id)
    pset(
        (8+x-char_x)*8+xoffset,
        (8+y-char_y)*8+yoffset,
        c
    )
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