Placement = {
    -- selected square
    sel_x_p=0, -- "precise" (sub-integer)
    sel_y_p=0,
    sel_x=0,
    sel_y=0,
    sel_sprite = "no_action",
    place_mode = "place_panel",
}

function Placement.set_place_mode(button_pressed)
    if button_pressed then
        if Placement.place_mode == "place_panel" then
            Placement.place_mode = "place_wire"
        else
            Placement.place_mode = "place_panel"
        end
    end
end
