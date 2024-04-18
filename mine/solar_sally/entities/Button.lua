Button = {
    ent_id = nil,
    is_being_pressed = false,
}

function Button.init()
    Button.ent_id = Entities.create_entity()
    Attributes_set_attr(Button.ent_id, Attr_WalkingObstruction, true)
    DrawFns.add(Button.ent_id, Button.draw_button)

    Actions_set_action(Button.ent_id, Sprite_id_button_mini, Button.press, Button.release)

    Locations.place_entity(Button.ent_id, -5, 0)
end

function Button.draw_button(x, y)
    if Button.is_being_pressed then
        Sprites.draw_spr(Sprite_id_button_pressed, x, y)
    else
        Sprites.draw_spr(Sprite_id_button, x, y)
    end
end

function Button.press()
    Button.is_being_pressed = true
    PanelCalculator.update(df_double("86400")) -- 86400 seconds = 24 hours
end

function Button.release()
    Button.is_being_pressed = false
end