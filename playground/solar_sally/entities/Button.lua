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
    Button_create_button("sleep 24h", -5, 0, Button_pressAdvanceTimeDays, nil, 1)
    Button_create_button("go inside", -5, 1, Button_pressGoInside)
    Button_create_button("unlock basement for $2", -5, 2, Button_pressUnlockBasement)
    Button_create_button("buy 1 transformer for $1000", -5, 3, Button_pressBuy, nil, Entities_Transformers_left, 1000, 1)
    Button_create_button("buy 10 wire for $1 ea", -5, 4, Button_pressBuy, nil, Entities_Wire, 1, 10)
    Button_create_button("buy 10 panels for $500", -5, 5, Button_pressBuy, nil, Entities_Panels, 50, 10)
    Button_create_button("buy 1 panel for $50", -5, 6, Button_pressBuy, nil, Entities_Panels, 50, 1)
    Button_create_button("buy axe for $100", -5, 7, Button_pressBuyAxe, nil, 100)
    Button_create_button("buy fence for $10", -5, 8, Button_pressBuy, nil, Entities_Fence, 10, 1)
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
    if(not Inventory_canAfford(cost)) return
    Inventory_addMoney(-cost)
    load_system(Axe)
end

function Button_pressGoInside()
    fadeAndDisableInputForCo(function ()
        unload_system(Placement)
        unload_system(World)

        load_system(IndoorWorld)
    end)
end

function Button_pressAdvanceTimeDays(d)
    fadeAndDisableInputForCo(function ()
        PanelCalculator_add_panel_days(d)
        Trees_advanceTimeDays(d)
        Cows_advanceTimeDays(d)
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
    -- TODO make key cost a setting
    if(not Inventory_canAfford(2)) return
    Inventory_addMoney(-2)
    Button_create_button("sleep 30d", -5, 11, Button_pressAdvanceTimeDays, nil, 30)
end