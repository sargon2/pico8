Inventory = {
    name = "Inventory",
    items = {}, -- items[ent_id] = count
    order = {}, -- order[] = ent_id -- just for display order
    stringFormatters = {} -- stringFormatters[ent_id] = fn(text)
}

function _money_format(m)
    -- Include everything up to the decimal, then stuff after the decimal until we fill to n digits
    local ret = "$"
    local after_decimal = false
    m = full_tostr(m)
    for c in all(m) do
        if c == '.' then
            after_decimal = true
        end
        ret ..= c
        if after_decimal and #ret >= 9 then
            break
        end
    end
    return ret
end

function Inventory.init()
    -- Since we haven't implemented buying yet, just start with some core components.
    -- Order here is display order
    Sprites_add(Entities_Money, Sprite_id_money)
    Inventory.addStringFormatter(Entities_Money, _money_format)
    Inventory.add(Entities_Money, 0)

    Inventory.add(Entities_Panels, Settings_start_panels)
    Inventory.add(Entities_Transformers_left, Settings_start_transformers)
    Inventory.add(Entities_Wire, Settings_start_wire) -- TODO should wire be infinite?
end

function Inventory.add(ent_id, num)
    if(not num) num = 1
    if not Inventory.items[ent_id] then
        Inventory.items[ent_id] = 0
        add(Inventory.order, ent_id)
    end
    Inventory.items[ent_id] += num
end

function Inventory.get(ent_id)
    return Inventory.items[ent_id]
end

function Inventory.addStringFormatter(ent_id, fn)
    Inventory.stringFormatters[ent_id] = fn
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
        Sprites_draw_relative_to_screen(sprite_id, spr_x, spr_y)
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
    --[[const]] local window_left = 0
    --[[const]] local window_top = 13
    --[[const]] local window_height = 3 -- #Inventory.order + 2
    --[[const]] local window_width = 16
    draw_window(window_left, window_top, window_width, window_height)
    local col = 0
    local row = 0
    for ent_id in all(Inventory.order) do
        local count = Inventory.items[ent_id]
        Attr_DrawFn[ent_id](window_left+1+col*3, window_top+1+row, ent_id, true)
        color(4)
        local fn = Inventory.stringFormatters[ent_id]
        if(fn) count = fn(count)
        print_text(count, window_left+2+col*3, window_top+1+row, 2, 2)
        col += 1
        if ent_id == Entities_Money then -- TODO hack
            col += 1
        end
    end
end
