Sprites = {}

Sprite_ids = {
    solar_panel = 17,
    transformer_left = 18,
    transformer_right = 19,
    cow_side = 22,
    cow_lookin = 23,
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

function Sprites.add(ent_id, sprite, width, height, yoffset)
    -- Sprite just forwards to TileDrawFns

    sprite = Sprite_ids[sprite]
    if(not width) width = 1
    if(not height) height = 1
    if(not yoffset) yoffset = 0

    function d(x, y)
        Sprites.draw_spr(sprite, x, y + yoffset, width, height)
    end

    TileDrawFns.add(ent_id, d)
end

-- function Sprites.add(ent_id, sprite, width, height, yoffset)
--     Sprites.sprites[ent_id] = Sprite_ids[sprite]
--     if width then
--         Sprites.widths[ent_id] = width
--     end
--     if height then
--         Sprites.heights[ent_id] = height
--     end
--     if yoffset then
--         Sprites.yoffsets[ent_id] = yoffset
--     end
-- end

-- function Sprites.drawSpriteAt(ent_id, x, y)
--     local sprite = Sprites.sprites[ent_id]

--     if(not sprite) return

--     local yoffset = Sprites.yoffsets[ent_id] or 0
--     local width = Sprites.widths[ent_id] or 1
--     local height = Sprites.heights[ent_id] or 1

--     Sprites.draw_spr(sprite, x, y + yoffset, width, height)
-- end

function Sprites.draw_spr(s,x,y,width,height)
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
        (8+x-Character.x)*8,
        (8+y-Character.y)*8,
        width,
        height
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