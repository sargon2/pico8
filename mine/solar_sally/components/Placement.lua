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
    if entity_at_sel == nil then
        if Placement.is_removing then
            -- If we have nothing selected, but we're removing, we take no action but retain the pick_up sprite.
            return "no_action", nil, "pick_up"
        else
            -- We're not removing and we have nothing selected, so we're placing the user's selected item.
            return "place", Placement.place_ent_id, Attributes.get_attr(Placement.place_ent_id, "placement_sprite")
        end
    end

    -- We have something selected

    -- If we're placing the currently selected item
    if entity_at_sel == Placement.is_placing then
        -- We can't re-place an item, but we let the user know we're still placing.
        return "no_action", nil, Attributes.get_attr(entity_at_sel, "placement_sprite")
    end

    -- If we're removing the currently selected item, pick it up.
    -- Note this will only happen for 1 frame because the item will be removed this frame
    if entity_at_sel == Placement.is_removing then
        return "pick_up", entity_at_sel, "pick_up"
    end

    -- If we're not placing or removing, and we have something pick-uppable selected, pick it up.
    if not Placement.is_placing and not Placement.is_removing and Attributes.get_attr(entity_at_sel, "pick_uppable") then
        return "pick_up", entity_at_sel, "pick_up"
    end

    -- No valid action was found.
    return "no_action", nil, "no_action"
end
