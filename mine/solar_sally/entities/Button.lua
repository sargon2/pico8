Button = {
    ent_id = nil,
    is_being_pressed = false,
}

-- TODO make the button depressed while being pressed

function Button.init()
    Button.ent_id = Entities.create_entity()
    Attributes.set_attr(Button.ent_id, "WalkingObstruction", true)
    DrawFns.add(Button.ent_id, Button.draw_button)

    -- Things we need to set up:
    -- - When you hover over the button, you should get an "action" mini-icon
    --   - There is complexity around the "x" -- if you're placing panels, should you need to select the press tool after highlighting the button, etc.
    -- - When you activate the button, it should do something

    Actions.set_action(Button.ent_id, "button_mini", Button.press, Button.release)

    Locations.place_entity(Button.ent_id, -5, 0)
end

function Button.draw_button(x, y)
    if Button.is_being_pressed then
        Sprites.draw_spr(Sprite_ids["button_pressed"], x, y)
    else
        Sprites.draw_spr(Sprite_ids["button"], x, y)
    end
end

function Button.press()
    Button.is_being_pressed = true
    printh("Button pressed")
end

function Button.release()
    Button.is_being_pressed = false
    printh("Button released")
end