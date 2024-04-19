Button = {
    is_being_pressed = false,
}

function Button.init()
    Attributes_set_attr(Entities_Button, Attr_WalkingObstruction, true)
    Attributes_set_attr(Entities_Button, Attr_DrawFn, Button.draw_button)
    Attributes_set_attr(Entities_Button, Attr_action_sprite, Sprite_id_button_mini)
    Attributes_set_attr(Entities_Button, Attr_action_fn, Button.press)
    Attributes_set_attr(Entities_Button, Attr_action_release_fn, Button.release)

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
    PanelCalculator.update(df_double("86400")) -- 86400 seconds = 24 hours
end

function Button.release()
    Button.is_being_pressed = false
end