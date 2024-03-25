Placement = {
    -- selected square
    sel_x_p=0, -- "precise" (sub-integer)
    sel_y_p=0,
    sel_x=0,
    sel_y=0,
    sel_sprite = "no_action",
    place_mode = nil, -- TODO rename this field place_ent_id
    is_placing = nil, -- ent id of what we're placing
    is_removing = nil, --ent id of what we're removing
}

function Placement.init()
    Placement.place_mode = Panels.ent_id -- by default we place panels
end

function Placement.draw_selection()
    Sprites.draw_spr("selection_box",Placement.sel_x,Placement.sel_y)
    Sprites.draw_spr(Placement.sel_sprite,Placement.sel_x,Placement.sel_y-1)
end

function Placement.set_place_mode(button_pressed)
    -- TODO rotate through items with "placeable" attribute
    if button_pressed then
        if Placement.place_mode == Panels.ent_id then
            Placement.place_mode = Wire.ent_id
        else
            Placement.place_mode = Panels.ent_id
        end
    end
end

function Placement.remove(ent_id, x, y)
    Placement.is_removing = ent_id
    Placement.place_mode = ent_id
    Locations.remove_entity(x, y)
end

function Placement.place(ent_id, x, y)
    Placement.is_placing = ent_id
    Placement.place_mode = ent_id
    Locations.place_entity(ent_id, Placement.sel_x, Placement.sel_y)
end

function Placement.determine_placement_sprite(entity_at_sel, action, action_ent)
    local sprite_from_entid = {
        [Panels.ent_id] = "place_panel",
        [Wire.ent_id] = "place_wire",
    }

    if entity_at_sel != nil and entity_at_sel == Placement.is_placing then
        return sprite_from_entid[entity_at_sel]
    end

    if Placement.is_removing then
        if entity_at_sel != nil then
            return "no_action"
        end
        return "pick_up"
    end

    if action == "place" then
        return sprite_from_entid[action_ent]
    end
    return action
end

function Placement.handle_selection_and_placement()
    Placement.set_place_mode(btnp(🅾️))

    -- Determine what we have selected
    local entity_at_sel = Locations.entity_at(Placement.sel_x, Placement.sel_y) -- may be nil

    -- 1. determine action -- no action, pick up, place
    local action, action_ent = Placement.determine_action(entity_at_sel)

    -- 2. determine sprite
    Placement.sel_sprite = Placement.determine_placement_sprite(entity_at_sel, action, action_ent)

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

function Placement.determine_action(entity_at_sel)
    local action = "no_action"  -- Default action
    local action_ent = nil

    local function is_removable(ent_id) -- TODO this should be an entity attribute
        if ent_id == Panels.ent_id then
            return true
        elseif ent_id == Wire.ent_id then
            return true
        end
        return false
    end

    if Placement.is_placing then
        if entity_at_sel == nil then
            -- We're in place mode but haven't selected a type; use the user's selected mode.
            action = "place"
            action_ent = Placement.place_mode
        end
    elseif Placement.is_removing then
        -- Check if the selected type has a mapped action for removing
        if is_removable(entity_at_sel) then
            action = "pick_up"
            action_ent = entity_at_sel
        end
    else
        -- Not placing or removing; check if we should pick up an item
        if is_removable(entity_at_sel) then
            action = "pick_up"
            action_ent = entity_at_sel
        elseif entity_at_sel == nil then
            -- If nothing's there, we're in place mode; use the user's selected mode.
            action = "place"
            action_ent = Placement.place_mode
        end
    end

    return action, action_ent
end
