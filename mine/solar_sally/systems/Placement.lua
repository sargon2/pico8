Placement = {
    -- selected square
    sel_x_p=0, -- "precise" (sub-integer)
    sel_y_p=0,
    sel_x=0,
    sel_y=0,
    sel_sprite = Sprite_id_no_action,
    is_placing = nil, -- ent id of what we're placing
    is_removing = nil, -- ent id of what we're removing
    is_acting = nil, -- ent id if what we're acting on
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
end

function Placement.get_name()
    return "Placement"
end

function Placement.update(elapsed)
    Placement.handle_selection_and_placement(elapsed)
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

function Placement.draw()
    Sprites.draw_spr(Sprite_id_selection_box,Placement.sel_x,Placement.sel_y)
    Sprites.draw_spr(Placement.sel_sprite,Placement.sel_x,Placement.sel_y-1)
end

function Placement.rotate_place_ent_id()
    Placement.placeable_index %= #Placement.placeable_entities
    Placement.placeable_index += 1

    Placement.place_ent_id = Placement.placeable_entities[Placement.placeable_index]
end

function Placement.rotate_with_inventory_check()
    local start_index = Placement.placeable_index
    Placement.rotate_place_ent_id()

    -- Does the player have one to place?
    while Inventory.get(Placement.place_ent_id) <= 0 do
        if Placement.placeable_index == start_index then
            -- Nothing to place
            Placement.place_ent_id = nil
            return
        end
        -- Rotate again
        Placement.rotate_place_ent_id()
    end
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
    Inventory.add(ent_id)
end

function Placement.place(ent_id, x, y)
    if not Inventory.check_and_remove(ent_id) then
        assert(false) -- Place failed inventory check
    end
    Placement.is_placing = ent_id
    Placement.place_ent_id = ent_id
    local fn = Placement.placement_fns[ent_id]
    if fn then
        fn(x, y)
    else
        Locations.place_entity(ent_id, x, y)
    end

    Circuits.recalculate() -- TODO this probably shouldn't live here
    if Inventory.get(ent_id) == 0 then
        -- That was our last one, rotate off it
        Placement.rotate_with_inventory_check()
    end
end

function Placement.handle_selection_and_placement()
    if btnp(🅾️) then
        Placement.rotate_with_inventory_check()
    end

    local entity_at_sel = Locations.entity_at(Placement.sel_x, Placement.sel_y) -- may be nil

    local action, action_ent, sprite = Placement.determine_action_and_sprite(entity_at_sel)
    Placement.sel_sprite = sprite

    if btn(❎) then
        if action == "no_action" then -- TODO passing around these strings as enums is weird
            -- pass
            if type(Placement.is_acting) == "number" then
                Actions_release(Placement.is_acting)
                Placement.is_acting = true
            end
        elseif action == "custom" then
            if not Placement.is_acting then
                -- Attributes_get_attr(action_ent, "Attr_action_trigger_fn")()
                Actions_trigger(action_ent)
                Placement.is_acting = action_ent
            end
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
        if Placement.is_acting then
            if type(Placement.is_acting) == "number" then -- TODO checking type here and above is a bit weird
                Actions_release(Placement.is_acting)
            end
            Placement.is_acting = nil
        end
    end
end

function Placement.determine_action_and_sprite(entity_at_sel)
    -- returns action, action_ent, sprite
    if entity_at_sel == nil then
        if not Placement.is_acting then
            if Placement.is_removing then
                -- If we have nothing selected, but we're removing, we take no action but retain the pick_up sprite.
                return "no_action", nil, Sprite_id_pick_up
            else
                -- Are there any smooth entities in the way?
                -- This is not World.is_obstructed because we already know there isn't a Locations entity obstructing
                if SmoothLocations.is_obstructed(Placement.sel_x, Placement.sel_y) then
                    return "no_action", nil, Sprite_id_no_action
                end
                -- Does the thing we're placing think this location is obstructed?
                local fn = Placement.obstructed_fns[Placement.place_ent_id]
                if fn and fn(Placement.sel_x, Placement.sel_y) then
                    return "no_action", nil, Sprite_id_no_action -- TODO should this be a custom sprite?
                end
                -- We're not removing and we have nothing selected, so we're placing the user's selected item.
                if not Placement.place_ent_id then
                    -- Nothing to place
                    return "no_action", nil, Sprite_id_no_action
                end
                return "place", Placement.place_ent_id, Attributes_get_attr(Placement.place_ent_id, Attr_placement_sprite)
            end
        end
    end

    -- We have something selected

    -- Is it an actionable entity?
    if not Placement.is_placing and not Placement.is_removing then
        local act_sprite = Actions_get_sprite(entity_at_sel)
        if act_sprite then
            return "custom", entity_at_sel, act_sprite
        end
    end

    if not Placement.is_acting then

        -- If we're placing the currently selected item
        if entity_at_sel == Placement.is_placing then
            -- We can't re-place an item, but we let the user know we're still placing.
            return "no_action", nil, Attributes_get_attr(entity_at_sel, Attr_placement_sprite)
        end

        -- If we're removing the currently selected item, pick it up.
        -- Note this will only happen for 1 frame because the item will be removed this frame
        if entity_at_sel == Placement.is_removing then
            return "pick_up", entity_at_sel, Sprite_id_pick_up
        end

        -- If we're not placing or removing, and we have something pick-uppable selected, pick it up.
        if not Placement.is_placing and not Placement.is_removing and Attributes_get_attr(entity_at_sel, Attr_removable) then
            return "pick_up", entity_at_sel, Sprite_id_pick_up
        end
    end

    -- No valid action was found.
    return "no_action", nil, Sprite_id_no_action
end
