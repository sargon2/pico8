Button = {
    is_being_pressed = false,
}

function Button.init()
    Attr_WalkingObstruction[Entities_Button] = true
    Attr_DrawFn[Entities_Button] = Button.draw_button
    Attr_action_sprite[Entities_Button] = Sprite_id_button_mini
    Attr_action_fn[Entities_Button] = Button.press
    Attr_action_release_fn[Entities_Button] = Button.release

    Locations_place_entity(Entities_Button, -5, 0)
end

function Button.draw_button(x, y)
    if Button.is_being_pressed then
        Sprites_draw_spr(Sprite_id_button_pressed, x, y)
    else
        Sprites_draw_spr(Sprite_id_button, x, y)
    end
end

function Button.press()
    Button.is_being_pressed = true

    CoroutineRunner_StartScript(function()
        Input_AllInputDisabled = true
        fadetoblack_fade_co()

        unload_system(Placement)
        unload_system(World)

        load_system(IndoorWorld)

        fadetoblack_fadein_co()
        Input_AllInputDisabled = false
    end)

    -- CoroutineRunner_StartScript(function ()
    --     Input_AllInputDisabled = true
    --     fadetoblack_fade_co()
    --     PanelCalculator.add_panel_8h(3) -- 3*8 = 24, so one day
    --     -- Wait some frames
    --     for i=1,50 do
    --         yield()
    --     end
    --     fadetoblack_fadein_co()
    --     Input_AllInputDisabled = false
    -- end)
end

function Button.release()
    Button.is_being_pressed = false
end