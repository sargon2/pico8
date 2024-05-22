Button = {}

local Button_is_being_pressed = nil
local Button_labels = {}

function Button_create_button(label, x, y, press_fn, release_fn, ...)
    local args = {...}
    local ent_id = Entities_create_entity()
    Button_labels[ent_id] = label

    Attr_WalkingObstruction[ent_id] = true
    Attr_DrawFn[ent_id] = Button_draw_button
    Attr_mini_sprite[ent_id] = Sprite_id_button_mini
    Attr_action_fn[ent_id] = function ()
        Button_is_being_pressed = ent_id
        if(press_fn) press_fn(unpack(args))
    end
    Attr_action_release_fn[ent_id] = function ()
        Button_is_being_pressed = nil
        if(release_fn) release_fn()
    end

    Locations_place_entity(ent_id, x, y)
end

function Button.init()
    Button_create_button("do nothing", -5, -1, nil)
    Button_create_button("go inside", -5, 1, Button_pressGoInside)
    Button_create_button("unlock basement for $"..tostr(Settings_key_cost), -5, 2, Button_pressUnlockBasement)
    Button_create_button("buy 1 transformer for $"..tostr(Settings_transformer_cost), -5, 3, Button_pressBuy, nil, Entities_Transformers_left, Settings_transformer_cost, 1)
    Button_create_button("buy "..tostr(Settings_wire_qty).." wire for $"..tostr(Settings_wire_cost).." ea", -5, 4, Button_pressBuy, nil, Entities_Wire, Settings_wire_cost, Settings_wire_qty)
    -- Button_create_button("buy 10 panels for $500", -5, 5, Button_pressBuy, nil, Entities_Panels, 50, 10)
    Button_create_button("buy 1 panel for $"..tostr(Settings_panel_cost), -5, 6, Button_pressBuy, nil, Entities_Panels, Settings_panel_cost, 1)
    Button_create_button("buy axe for $"..tostr(Settings_axe_cost), -5, 7, Button_pressBuyAxe, nil, Settings_axe_cost)
    Button_create_button("buy fence for $"..tostr(Settings_fence_cost), -5, 8, Button_pressBuy, nil, Entities_Fence, Settings_fence_cost, 1)
end

function Button_draw_button(x, y, ent_id)
    if Button_is_being_pressed == ent_id then
        Sprites_draw_spr(Sprite_id_button_pressed, x, y)
    else
        Sprites_draw_spr(Sprite_id_button, x, y)
    end
    Sprites_print_text(Button_labels[ent_id], 1, x+1, y, 2, 2, false)
end

function _buy(buy_ent, price, qty)
    if(not Inventory_canAfford(price * qty)) return
    Inventory_add(buy_ent, qty)
    Inventory_addMoney(-(price * qty))
end

function Button_pressBuy(buy_ent, price, qty)
    _buy(buy_ent, price, qty)
end

function Button_pressBuyAxe(cost)
    if(system_is_loaded(Axe)) return
    if(not Inventory_canAfford(cost)) return
    Inventory_addMoney(-cost)
    load_system(Axe)
end

function Button_pressGoInside()
    fadeAndDisableInputForCo(function ()
        unload_system(Placement)
        unload_system(World)

        load_system(IndoorWorld, 2)
    end)
end

function Button_pressAdvanceTimeDays(d)
    fadeAndDisableInputForCo(function ()
        advance_time_days(d)
        -- Wait some frames
        for _=1,50 do
            yield()
        end
    end)
end

function Button_pressAdvanceTimeYears(y)
    fadeAndDisableInputForCo(function ()
        PanelCalculator_add_panel_years(y)
        Trees_advanceTimeYears(y)
        -- Wait some frames
        for _=1,50 do
            yield()
        end
    end)
end

function Button_pressUnlockBasement()
    if(Inventory_has_key) return
    if(not Inventory_canAfford(Settings_key_cost)) return
    Inventory_addMoney(-Settings_key_cost)
    Inventory_has_key = true
    Inventory_addIcon(Sprite_id_inventory_key)
    Button_create_button("sleep 30d", -5, 11, Button_pressAdvanceTimeDays, nil, 30)
end
