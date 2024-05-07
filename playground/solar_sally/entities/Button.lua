Button = {
    is_being_pressed = nil,
    labels = {}
}

function Button_create_button(label, x, y, press_fn, release_fn, ...)
    local args = {...}
    local ent_id = Entities_create_entity()
    Button.labels[ent_id] = label

    Attr_WalkingObstruction[ent_id] = true
    Attr_DrawFn[ent_id] = Button.draw_button
    Attr_mini_sprite[ent_id] = Sprite_id_button_mini
    Attr_action_fn[ent_id] = function ()
        Button.is_being_pressed = ent_id
        if(press_fn) press_fn(unpack(args))
    end
    Attr_action_release_fn[ent_id] = function ()
        Button.is_being_pressed = nil
        if(release_fn) release_fn()
    end

    Locations_place_entity(ent_id, x, y)
end

function Button.init()
    Button_create_button("24h", -5, 0, Button.pressAdvanceTimeDays, nil, 1)
    Button_create_button("go inside", -5, 1, Button.pressGoInside)
    Button_create_button("unlock basement for $2", -5, 2, Button.pressUnlockBasement)
    Button_create_button("buy 1 transformer for $1000", -5, 3, Button.pressBuy, nil, Entities_Transformers_left, 1000, 1)
    Button_create_button("buy 10 wire for $1 ea", -5, 4, Button.pressBuy, nil, Entities_Wire, 1, 10)
    Button_create_button("buy 10 panels for $500", -5, 5, Button.pressBuy, nil, Entities_Panels, 50, 10)
    Button_create_button("buy 1 panel for $50", -5, 6, Button.pressBuy, nil, Entities_Panels, 50, 1)
    Button_create_button("buy axe for $100", -5, 7, Button.pressBuyAxe, nil, 100)
end

function Button.draw_button(x, y, ent_id)
    if Button.is_being_pressed == ent_id then
        Sprites_draw_spr(Sprite_id_button_pressed, x, y)
    else
        Sprites_draw_spr(Sprite_id_button, x, y)
    end
    Sprites_print_text(Button.labels[ent_id], 1, x+1, y, 2, 2, false)
end

function _buy(buy_ent, price, qty)
    if(not Inventory_canAfford(price * qty)) return
    Inventory.add(buy_ent, qty)
    Inventory_addMoney(-(price * qty))
end

function Button.pressBuy(buy_ent, price, qty)
    _buy(buy_ent, price, qty)
end

function Button.pressBuyAxe(cost)
    if(not Inventory_canAfford(cost)) return
    Inventory_addMoney(-cost)
    load_system(Axe)
end

function Button.pressGoInside()
    fadeAndDisableInputForCo(function ()
        unload_system(Placement)
        unload_system(World)

        load_system(IndoorWorld)
    end)
end

function Button.pressAdvanceTimeDays(d)
    fadeAndDisableInputForCo(function ()
        PanelCalculator.add_panel_days(d)
        Trees_advanceTimeDays(d)
        -- Wait some frames
        for _=1,50 do
            yield()
        end
    end)
end

function Button.pressAdvanceTimeYears(y)
    fadeAndDisableInputForCo(function ()
        PanelCalculator.add_panel_years(y)
        Trees_advanceTimeYears(y)
        -- Wait some frames
        for _=1,50 do
            yield()
        end
    end)
end

function Button.pressUnlockBasement()
    -- TODO make key cost a setting
    if(not Inventory_canAfford(2)) return
    Inventory_addMoney(-2)
    -- Button_create_button("50y", -5, 7, Button.pressAdvanceTimeYears, nil, 50)
    -- Button_create_button("10y", -5, 8, Button.pressAdvanceTimeYears, nil, 10)
    -- Button_create_button("1y", -5, 9, Button.pressAdvanceTimeYears, nil, 1)
    Button_create_button("30d", -5, 10, Button.pressAdvanceTimeDays, nil, 30)
    -- Button_create_button("7d", -5, 11, Button.pressAdvanceTimeDays, nil, 7)
end