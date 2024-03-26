Placement = {
    -- selected square
    sel_x_p=0, -- "precise" (sub-integer)
    sel_y_p=0,
    sel_x=0,
    sel_y=0,
    sel_sprite = "no_action",
    place_ent_id = nil,
    is_placing = nil, -- ent id of what we're placing
    is_removing = nil, --ent id of what we're removing
}

function Placement.init()
    Placement.place_ent_id = Panels.ent_id -- by default we place panels
end

function Placement.draw_selection()
    Sprites.draw_spr("selection_box",Placement.sel_x,Placement.sel_y)
    Sprites.draw_spr(Placement.sel_sprite,Placement.sel_x,Placement.sel_y-1)
end

function Placement.set_place_ent_id(button_pressed)
    -- TODO rotate through items with "placeable" attribute
    if button_pressed then
        if Placement.place_ent_id == Panels.ent_id then
            Placement.place_ent_id = Wire.ent_id
        else
            Placement.place_ent_id = Panels.ent_id
        end
    end
end

function Placement.remove(ent_id, x, y)
    Placement.is_removing = ent_id
    Placement.place_ent_id = ent_id
    Locations.remove_entity(x, y)
end

function Placement.place(ent_id, x, y)
    Placement.is_placing = ent_id
    Placement.place_ent_id = ent_id
    Locations.place_entity(ent_id, Placement.sel_x, Placement.sel_y)
end

function Placement.handle_selection_and_placement()
    Placement.set_place_ent_id(btnp(🅾️))

    -- Determine what we have selected
    local entity_at_sel = Locations.entity_at(Placement.sel_x, Placement.sel_y) -- may be nil

    -- 1. determine action -- no action, pick up, place
    -- local action, action_ent = Placement.determine_action(entity_at_sel)

    -- 2. determine sprite
    -- Placement.sel_sprite = Placement.determine_placement_sprite(entity_at_sel, action, action_ent)

    local action, action_ent, sprite = Placement.determine_action_and_sprite(entity_at_sel)
    Placement.sel_sprite = sprite -- TODO can this be inlined?

    -- 3. take action if button pressed, and set placement/removal state

    if btn(❎) then
        if action == "no_action" then
            -- pass
        elseif action == "pick_up" then
            Placement.remove(action_ent, Placement.sel_x, Placement.sel_y)
        elseif action == "place" then
            Placement.place(action_ent, Placement.sel_x, Placement.sel_y)
        else
            assert(false) -- unknown action
        end
    else
        Placement.is_placing = nil
        Placement.is_removing = nil
    end
end

function Placement.determine_action_and_sprite(entity_at_sel)
    local action, action_ent, sprite

    if Placement.is_placing then
        -- entity_at_sel can be nil, equal to is_placing, or something else
        if entity_at_sel == nil then
            -- We're in place mode but haven't selected a type; use the user's selected mode.
            action = "place"
            action_ent = Placement.place_ent_id
            sprite = Attributes.get_attr(Placement.place_ent_id, "placement_sprite")
        elseif entity_at_sel == Placement.is_placing then
            action = "no_action"
            action_ent = nil
            sprite = Attributes.get_attr(entity_at_sel, "placement_sprite")
        else
            action = "no_action"
            action_ent = nil
            sprite = "no_action"
        end
    elseif Placement.is_removing then
        -- Keep removing the same type of thing only
        if entity_at_sel == nil then
            action = "no_action"
            action_ent = nil
            sprite = "pick_up"
        elseif entity_at_sel == Placement.is_removing then
            action = "pick_up"
            action_ent = entity_at_sel
            sprite = "pick_up" -- note this sprite won't be rendered for more than 1 frame because the ent will be removed this frame
        else
            -- We're removing, but have something we're not removing selected
            action = "no_action"
            action_ent = nil
            sprite = "no_action"
        end
    else
        -- Not placing or removing; check if we should pick up an item
        if entity_at_sel == nil then
            -- If nothing's there, we're in place mode; use the user's selected mode.
            action = "place"
            action_ent = Placement.place_ent_id
            sprite = Attributes.get_attr(Placement.place_ent_id, "placement_sprite")
        elseif Attributes.get_attr(entity_at_sel, "pick_uppable") then
            action = "pick_up"
            action_ent = entity_at_sel
            sprite = "pick_up"
        else
            action = "no_action"
            action_ent = nil
            sprite = "no_action"
        end
    end

    return action, action_ent, sprite
end
