Sprites = {
    solar_panel = 17,
    transformer_left = 18,
    transformer_right = 19,
    solar_panel_overlay_ul = 21,
    solar_panel_overlay_ur = 22,
    solar_panel_overlay_ll = 37,
    solar_panel_overlay_lr = 38,
    solar_panel_overlay_ll_short_leg = 53,
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
}

function Sprites.draw_spr(s,x,y)
    s = Sprites[s]
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
        (8+x-Character.x)*8,
        (8+y-Character.y)*8
    )
    if changed_transparency then
        palt()
    end
end

function Sprites.set_pixel(x,y,xoffset,yoffset,c) -- TODO where should this live?
    pset(
        (8+x-Character.x)*8+xoffset,
        (8+y-Character.y)*8+yoffset,
        c
    )
end

function Sprites.rect(x,y,xmin,ymin,xmax,ymax,c) -- TODO where should this live?
    rect(
        (8+x-Character.x)*8+xmin,
        (8+y-Character.y)*8+ymin,
        (8+x-Character.x)*8+xmax,
        (8+y-Character.y)*8+ymax,
        c
    )
end