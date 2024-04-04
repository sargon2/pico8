Placement = {
    -- selected square
    sel_x_p=0, -- "precise" (sub-integer)
    sel_y_p=0,
    sel_x=0,
    sel_y=0,
    sel_sprite = "no_action",
    is_placing = nil, -- ent id of what we're placing
    is_removing = nil, --ent id of what we're removing
    placeable_entities = nil,
    placeable_index = 1,
    place_ent_id = nil, -- technically redundant, but it's simpler and faster to cache it
    placement_fns = {},
    removal_fns = {},
    obstructed_fns = {},
}

function Placement.init()
    -- Add placeable entities in the same order they'll show up to the user
    Placement.placeable_entities = {Panels.ent_id, Wire.ent_id, Transformers.ent_left}
    Placement.place_ent_id = Placement.placeable_entities[Placement.placeable_index]
    Drawable.add_aggregate_draw_fn(ZValues["Placement"], Placement.draw_selection)
end

function Placement.update(elapsed)
    Placement.handle_selection_and_placement()
end

-- TODO these set_fn methods are weird and only needed since not all entities are exactly 1 tile
function Placement.set_placement_fn(ent_id, fn)
    Placement.placement_fns[ent_id] = fn
end

function Placement.set_removal_fn(ent_id, fn)
    Placement.removal_fns[ent_id] = fn
end

function Placement.set_placement_obstruction_fn(ent_id, fn)
    Placement.obstructed_fns[ent_id] = fn
end

function Placement.draw_selection()
    Sprites.draw_spr("selection_box",Placement.sel_x,Placement.sel_y)
    Sprites.draw_spr(Placement.sel_sprite,Placement.sel_x,Placement.sel_y-1)
end

function Placement.rotate_place_ent_id()
    Placement.placeable_index %= #Placement.placeable_entities
    Placement.placeable_index += 1

    Placement.place_ent_id = Placement.placeable_entities[Placement.placeable_index]
end

function Placement.remove(ent_id, x, y)
    local fn = Placement.removal_fns[ent_id]
    if fn then
        local e = fn(x, y)
        if e then
            ent_id = e
        end
    else
        Locations.remove_entity(x, y)
    end
    Placement.is_removing = ent_id
    Placement.place_ent_id = ent_id

    Circuits.recalculate() -- TODO this probably shouldn't live here
end

function Placement.place(ent_id, x, y)
    Placement.is_placing = ent_id
    Placement.place_ent_id = ent_id
    local fn = Placement.placement_fns[ent_id]
    if fn then
        fn(x, y)
    else
        Locations.place_entity(ent_id, x, y)
    end

    Circuits.recalculate() -- TODO this probably shouldn't live here
end

function Placement.handle_selection_and_placement()
    if btnp(🅾️) then
        Placement.rotate_place_ent_id()
    end

    local entity_at_sel = Locations.entity_at(Placement.sel_x, Placement.sel_y) -- may be nil

    local action, action_ent, sprite = Placement.determine_action_and_sprite(entity_at_sel)
    Placement.sel_sprite = sprite

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
            local fn = Placement.obstructed_fns[Placement.place_ent_id]
            if fn and fn(Placement.sel_x, Placement.sel_y) then
                return "no_action", nil, "no_action" -- TODO should this be a custom sprite?
            end
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
    if not Placement.is_placing and not Placement.is_removing and Attributes.get_attr(entity_at_sel, "removable") then
        return "pick_up", entity_at_sel, "pick_up"
    end

    -- No valid action was found.
    return "no_action", nil, "no_action"
end
