Inventory = {
    items = {}, -- items[ent_id] = count
    order = {}, -- order[] = ent_id -- just for display order
}

function Inventory.init()
    -- Since we haven't implemented buying yet, just start with some core components.
    -- Order here is display order
    Inventory.add(Panels.ent_id, Settings.start_panels)
    Inventory.add(Transformers.ent_left, Settings.start_transformers)
    Inventory.add(Wire.ent_id, Settings.start_wire) -- TODO should wire be infinite?
end

function Inventory.add(ent_id, num)
    if(not num) num = 1
    if not Inventory.items[ent_id] then
        Inventory.items[ent_id] = 0 -- TODO is this needed?
        add(Inventory.order, ent_id)
    end
    Inventory.items[ent_id] += num
end

function Inventory.get(ent_id)
    return Inventory.items[ent_id]
end

function Inventory.check_and_remove(ent_id)
    -- Returns ent id if succeeded, nil otherwise
    if Inventory.items[ent_id] and Inventory.items[ent_id] > 0 then
        Inventory.items[ent_id] -= 1
        return ent_id
    end
    return nil
end

function draw_window(x, y, width, height) -- TODO where should this live?
    local function _draw_spr(sprite_id, spr_x, spr_y)
        Sprites.draw_relative_to_screen(sprite_id, spr_x, spr_y)
    end

    _draw_spr(Sprite_id_window_ul, x, y)
    for i = x+1,x+width-2 do
        _draw_spr(Sprite_id_window_u, i, y)
    end
    _draw_spr(Sprite_id_window_ur, x+width-1, y)

    for j = y+1,y+height-2 do
        _draw_spr(Sprite_id_window_l, x, j)
        for i = x+1,x+width-2 do
            _draw_spr(Sprite_id_window_m, i, j)
        end
        _draw_spr(Sprite_id_window_r, x+width-1, j)
    end

    _draw_spr(Sprite_id_window_bl, x, y+height-1)
    for i = x+1,x+width-2 do
        _draw_spr(Sprite_id_window_b, i, y+height-1)
    end
    _draw_spr(Sprite_id_window_br, x+width-1, y+height-1)
end

function print_text(text, x, y, xoffset, yoffset) -- TODO where should this live?
    print(text, x*8+xoffset, y*8+yoffset)
end

function Inventory.draw()
    -- TODO ui paper prototyping to tell where this window should go
    draw_window(12, 3, 4, #Inventory.order + 2)
    local row = 0
    for ent_id in all(Inventory.order) do
        local count = Inventory.items[ent_id]
        DrawFns.drawTileAt(ent_id, 13, 4+row, true)
        color(4)
        print_text(count, 14, 4+row, 2, 2)
        row += 1
    end
end
