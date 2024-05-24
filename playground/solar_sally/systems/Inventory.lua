Inventory = {}

local Inventory_items = {} -- items[ent_id] = count
local Inventory_icons = {}

Inventory_has_key = false

function Inventory__money_format(m)
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

function Inventory.on_load()
    -- Since we haven't implemented buying yet, just start with some core components.
    -- Order here is display order
    Sprites_add(Entities_Money, Sprite_id_money)
    Inventory_items[Entities_Money] = NewObj(twonum, Settings_start_money)
    if Settings_cheat_lotsofmoney then
        for _=1,10000 do
            Inventory_addMoney(30000)
        end
        Inventory_addMoney(0.25)
    end

    Inventory_add(Entities_Panels, Settings_start_panels)
    Inventory_add(Entities_Transformers_left, Settings_start_transformers)
    Inventory_add(Entities_Wire, Settings_start_wire)
    Inventory_add(Entities_Fence, Settings_start_fence)
end

function Inventory_add(ent_id, num) -- Does not work for money.
    if(not num) num = 1
    if(not Inventory_items[ent_id]) Inventory_items[ent_id] = 0
    Inventory_items[ent_id] += num
end

function Inventory_addMoney(amount)
    Inventory_items[Entities_Money]:add(amount)
end

function Inventory_addIcon(icon)
    add(Inventory_icons, icon)
end

function Inventory_canAfford(amount)
    return Inventory_get(Entities_Money):cmp(amount) <= 0
end

function Inventory_get(ent_id)
    return Inventory_items[ent_id]
end

function Inventory_check_and_remove(ent_id)
    -- Returns ent id if succeeded, nil otherwise
    if Inventory_items[ent_id] and Inventory_items[ent_id] > 0 then
        Inventory_items[ent_id] -= 1
        return ent_id
    end
    return nil
end

function draw_window(x, y, width, height)
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

local Inventory_locations = {
    [Entities_Money] = {1, 14.5},
    [Entities_Panels] = {1, 13.5},
    [Entities_Transformers_left] = {4.5, 13.5},
    [Entities_Wire] = {8, 13.5},
    [Entities_Fence] = {11.5, 13.5},
}

--[[const]] icon_x_start = 14.25 -- starts right and moves left
--[[const]] icon_y = 14.5

local should_draw_fence = false

function Inventory.draw()
    --[[const]] local window_left = 0
    --[[const]] local window_top = 13
    --[[const]] local window_height = 3
    --[[const]] local window_width = 16
    draw_window(window_left, window_top, window_width, window_height)

    for ent_id, loc in pairs(Inventory_locations) do
        local count = Inventory_items[ent_id]
        if(ent_id == Entities_Fence and count > 0) should_draw_fence = true
        if(ent_id != Entities_Fence or should_draw_fence) then
            Attr_DrawFn[ent_id](loc[1], loc[2], ent_id, true)
            if(ent_id == Entities_Money) count = Inventory__money_format(count)
            Sprites_print_text(count, 4, loc[1]+1, loc[2], 2, 2, true)
        end
    end

    -- Draw icons
    local x = icon_x_start
    for icon in all(Inventory_icons) do
        Sprites_draw_relative_to_screen(icon,x,icon_y)
        x -= 1
    end
end
