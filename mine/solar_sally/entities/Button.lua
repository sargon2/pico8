Button = {
    is_being_pressed = nil,
    labels = {}
}

function Button_create_button(label, x, y, press_fn, release_fn)
    local ent_id = Entities_create_entity()
    Button.labels[ent_id] = label

    Attr_WalkingObstruction[ent_id] = true
    Attr_DrawFn[ent_id] = Button.draw_button
    Attr_action_sprite[ent_id] = Sprite_id_button_mini
    Attr_action_fn[ent_id] = function ()
        Button.is_being_pressed = ent_id
        if(press_fn) press_fn()
    end
    Attr_action_release_fn[ent_id] = function ()
        Button.is_being_pressed = nil
        if(release_fn) release_fn()
    end

    Locations_place_entity(ent_id, x, y)
end

function Button.init()
    Button_create_button("advance time", -5, 0, Button.pressAdvanceTime)
    Button_create_button("go inside", -5, 1, Button.pressGoInside)
end

function Button.draw_button(x, y, ent_id)
    if Button.is_being_pressed == ent_id then
        Sprites_draw_spr(Sprite_id_button_pressed, x, y)
    else
        Sprites_draw_spr(Sprite_id_button, x, y)
    end
    Sprites_print_text(Button.labels[ent_id], 1, x+1, y, 2, 2, false)
end

function Button.pressGoInside()
    CoroutineRunner_StartScript(function()
        Input_AllInputDisabled = true
        fadetoblack_fade_co()

        unload_system(Placement)
        unload_system(World)

        load_system(IndoorWorld)

        fadetoblack_fadein_co()
        Input_AllInputDisabled = false
    end)
end

function Button.pressAdvanceTime()
    CoroutineRunner_StartScript(function ()
        Input_AllInputDisabled = true
        fadetoblack_fade_co()
        PanelCalculator.add_panel_8h(3) -- 3*8 = 24, so one day
        -- Wait some frames
        for i=1,50 do
            yield()
        end
        fadetoblack_fadein_co()
        Input_AllInputDisabled = false
    end)
end