Inventory = {
    name = "Inventory"
}

local Inventory_items = {} -- items[ent_id] = count
local Inventory_order = {} -- order[] = ent_id -- just for display order
local Inventory_formatters = {} -- formatters[ent_id] = fn(text)
local Inventory_icons = {}

function _money_format(m)
    -- Include everything up to the decimal, then stuff after the decimal until we fill to n digits
    local ret = "$"
    local after_decimal = false
    m = m:tostr()
    for c in all(m) do
        if c == '.' then
            after_decimal = true
        end
        if after_decimal and #ret >= 9 then
            break
        end
        ret ..= c
    end
    return ret
end

function Inventory.init()
    -- Since we haven't implemented buying yet, just start with some core components.
    -- Order here is display order
    Sprites_add(Entities_Money, Sprite_id_money)
    Inventory_addFormatter(Entities_Money, _money_format)
    Inventory_items[Entities_Money] = NewObj(twonum, Settings_start_money)
    if Settings_cheat_lotsofmoney then
        for _=1,10000 do
            Inventory_addMoney(30000)
        end
        Inventory_addMoney(0.25)
    end
    add(Inventory_order, Entities_Money)

    Inventory_add(Entities_Panels, Settings_start_panels)
    Inventory_add(Entities_Transformers_left, Settings_start_transformers)
    Inventory_add(Entities_Wire, Settings_start_wire) -- TODO should wire be infinite?
    Inventory_add(Entities_Fence, Settings_start_fence)
end

function Inventory_add(ent_id, num) -- Does not work for money.
    if(not num) num = 1
    if not Inventory_items[ent_id] then
        Inventory_items[ent_id] = 0
        add(Inventory_order, ent_id)
    end
    Inventory_items[ent_id] += num
end

function Inventory_addMoney(amount)
    Inventory_items[Entities_Money]:add(amount)
end

function Inventory_addIcon(icon)
    add(Inventory_icons, icon)
end

function Inventory_canAfford(amount)
    if(Inventory_get(Entities_Money):cmp(amount) > 0) return false -- can't afford
    return true
end

function Inventory_get(ent_id)
    return Inventory_items[ent_id]
end

function Inventory_addFormatter(ent_id, fn)
    Inventory_formatters[ent_id] = fn
end

function Inventory_check_and_remove(ent_id)
    -- Returns ent id if succeeded, nil otherwise
    if Inventory_items[ent_id] and Inventory_items[ent_id] > 0 then
        Inventory_items[ent_id] -= 1
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

function Inventory.draw()
    --[[const]] local window_left = 0
    --[[const]] local window_top = 13
    --[[const]] local window_height = 3 -- #Inventory_order + 2
    --[[const]] local window_width = 16
    draw_window(window_left, window_top, window_width, window_height)
    local col = 0
    local row = 0
    for ent_id in all(Inventory_order) do
        local count = Inventory_items[ent_id]
        Attr_DrawFn[ent_id](window_left+1+col*3, window_top+1.25+row, ent_id, true)
        local fn = Inventory_formatters[ent_id]
        if(fn) count = fn(count)
        Sprites_print_text(count, 4, window_left+2+col*3, window_top+1.25+row, 2, 2, true)
        col += 1
        if ent_id == Entities_Money then -- TODO hack
            col += 1
        end
    end

    -- Draw icons
    local x = 14.25
    for icon in all(Inventory_icons) do
        Sprites_draw_relative_to_screen(icon,x,13.25)
        x -= 1
    end
end
