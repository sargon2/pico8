-- Placement

local in_limbo = nil -- the piece we're placing that's been taken out of our inventory but hasn't been placed yet

-- Start placing

function start_placing(act_id, x, y)
    if Locations_entity_at(x, y) != nil then
        return false
    end

    -- Get the placement id from the action id
    local ent_id_from_action_id = {
        [Actions_place_panel] = Entities_Panels,
        [Actions_place_wire] = Entities_Wire,
        [Actions_place_transformer] = Entities_Transformers_left
    }
    local ent_id = ent_id_from_action_id[act_id]

    -- The inventory check has to be the last check since it removes the item from inventory.
    if not Inventory_check_and_remove(ent_id) then
        return false
    end

    in_limbo = ent_id

    Actions_start_timed_action(complete_placing_ent, Attr_action_speed[ent_id], ent_id, x, y)

    return true
end

-- Complete placing
function complete_placing_ent(ent_id, x, y)
    Locations_place_entity(ent_id, x, y)
    if(ent_id == Entities_Transformers_left) then
        Locations_place_entity(Entities_Transformers_right, x+1, y)
    end
    Circuits_recalculate()
    shake_screen()
end

-- Cancel placing
function cancel_placing()
    if(in_limbo) Inventory_add(in_limbo)
    in_limbo = nil
end


-- Removal

-- Start removing
function start_removing(_act, x, y)
    local ent_id = Locations_entity_at(x, y)
    if not Attr_removable[ent_id] then
        return false
    end

    Actions_start_timed_action(complete_removal, Attr_removal_speed[ent_id], ent_id, x, y)
    return true
end

-- Complete removal
function complete_removal(ent_id, x, y, skip_add)
    Locations_remove_entity(x, y)
    if ent_id == Entities_Transformers_left or ent_id == Entities_Transformers_right then
        Locations_remove_entity(x + (ent_id == Entities_Transformers_left and 1 or -1), y)
        if not skip_add then Inventory_add(Entities_Transformers_left) end
    elseif not skip_add then
        Inventory_add(ent_id)
    end

    Circuits_recalculate()
end
