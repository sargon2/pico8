Placement = {}

-- selected square
local Placement_sel_x_p=0 -- "precise" (sub-integer)
local Placement_sel_y_p=0
local Placement_sel_x=0 -- should always equal flr(sel_x_p)
local Placement_sel_y=0 -- should always equal flr(sel_y_p)
local Placement_sel_x_visual = 0 -- for juicy animations
local Placement_sel_y_visual = 0

local Placement_sel_sprite = Sprite_id_no_action

-- State related to the user's current action
local Placement_current_action = Actions_no_action
local Placement_current_action_ent = nil

-- State related to what we'll place next.
local Placement_placeable_entities = nil
local Placement_placeable_index = nil

-- Custom functions for Transformer since it's 2 tiles wide
local Placement_placement_fns = {}
local Placement_removal_fns = {}
local Placement_obstructed_fns = {}

-- State for progress indicator
Placement_placing_coroutine = nil
Placement_progress = nil -- 0 to 1

function Placement.init()
    -- Add placeable entities in the same order they'll show up to the user
    Placement_placeable_entities = {Entities_None, Entities_Panels, Entities_Wire, Entities_Transformers_left, Entities_Fence}
    Placement_placeable_index = nil -- To reset rotation in tests
    Placement_rotate_with_inventory_check(false, true) -- Set the placement icon to "no action" or the first thing, if we have anything
end

function Placement.update(_elapsed)
    if my_btnp(Button_select_action) then
        Placement_rotate_with_inventory_check()
    end

    if(Placement_get_place_ent_id() == Entities_None) return

    local entity_at_sel = Locations_entity_at(Placement_sel_x, Placement_sel_y) -- may be nil

    -- Determine what possible action we could take
    local action, action_ent, sprite = Placement_determine_action_and_sprite(entity_at_sel)
    -- Display that action to the user
    Placement_sel_sprite = sprite

    -- Carry out the action
    if my_btn(Button_take_action) then
        if action == Actions_custom then
            Placement_custom_action(action_ent, Placement_sel_x, Placement_sel_y)
        elseif action == Actions_pick_up then
            Placement_begin_timed_action(Attr_removal_speed[action_ent], Placement_complete_remove, action_ent, Placement_sel_x, Placement_sel_y)
        elseif action == Actions_place then
            Placement_begin_timed_action(Attr_placement_speed[action_ent], Placement_complete_place, action_ent, Placement_sel_x, Placement_sel_y)
        end
        if action ~= Actions_no_action then
            Placement_current_action = action
            Placement_current_action_ent = action_ent
        end
    else
        -- Were we taking a custom action that we now have to release?
        if Placement_current_action == Actions_custom then
            Attr_action_release_fn[Placement_current_action_ent]()
        end
        Placement_current_action = Actions_no_action
        Placement_current_action_ent = nil

        -- Cancel any placement in progress
        Placement_cancel_timed_action()
    end
end

function Placement_set_placement_fn(ent_id, fn)
    Placement_placement_fns[ent_id] = fn
end

function Placement_set_removal_fn(ent_id, fn)
    Placement_removal_fns[ent_id] = fn
end

function Placement_set_placement_obstruction_fn(ent_id, fn)
    Placement_obstructed_fns[ent_id] = fn
end

function Placement.draw()
    if(Placement_get_place_ent_id() == Entities_None) return
    Sprites_draw_spr(Sprite_id_selection_box,Placement_sel_x_visual,Placement_sel_y_visual)
    Sprites_draw_spr(Placement_sel_sprite,Placement_sel_x_visual,Placement_sel_y_visual-1)

    -- Progress indicator
    if(Placement_progress != nil) then
        Sprites_draw_line(
            Placement_sel_x_visual,
            Placement_sel_y_visual+1,
            lerp(Placement_sel_x_visual, Placement_sel_x_visual+(7/8), Placement_progress),
            Placement_sel_y_visual+1,
            11
        )
    end
end

function Placement_get_place_ent_id() -- return what the user would like to place next
    if(Placement_placeable_index == nil) return nil
    return Placement_placeable_entities[Placement_placeable_index]
end

function Placement_rotate_with_inventory_check(skip_off, skip_sfx)
    if(Placement_placeable_index == nil) Placement_placeable_index = #Placement_placeable_entities -- since it'll get advanced at least once in the loop

    local started_on_none = (Placement_get_place_ent_id() == Entities_None)

    local ent_id
    repeat
        -- Advance
        Placement_placeable_index %= #Placement_placeable_entities
        Placement_placeable_index += 1

        ent_id = Placement_get_place_ent_id()

        -- Check for empty inventory
        if started_on_none and ent_id == Entities_None then
            Placement_placeable_index = nil
            if not skip_sfx then
                if started_on_none then
                    sfx(SFX_id_activate_placement)
                else
                    sfx(SFX_id_rotate_placement)
                end
            end
            return nil
        end

        -- Does the player have one to place?
    until ent_id == Entities_None or Inventory_get(ent_id) > 0

    -- If we're skipping none, we can just rotate again since we never rotate None -> None, only None -> nil.
    if(skip_off and ent_id == Entities_None) ent_id = Placement_rotate_with_inventory_check(false, true)

    -- SFX
    if not skip_sfx then
        if started_on_none and ent_id != Entities_None then
            sfx(SFX_id_activate_placement)
        elseif not started_on_none and ent_id == Entities_None then
            sfx(SFX_id_deactivate_placement)
        else
            sfx(SFX_id_rotate_placement)
        end
    end

    return ent_id
end

function Placement_set_place_ent(ent_id)
    -- Careful! Only call this if you know the user has at least one in their inventory.
    for i, e in pairs(Placement_placeable_entities) do
        if ent_id == e then
            Placement_placeable_index = i
            return
        end
    end
end

function Placement_complete_remove(ent_id, x, y)
    local fn = Placement_removal_fns[ent_id]
    if fn then
        local e = fn(x, y)
        if e then
            ent_id = e
        end
    else
        Locations_remove_entity(x, y)
    end
    Inventory_add(ent_id)

    Placement_set_place_ent(ent_id) -- Set the next placement item to the one we just picked up for convenience
    Circuits_recalculate()
end

function Placement_cancel_timed_action()
    Placement_progress = nil
    CoroutineRunner_Cancel(Placement_placing_coroutine)
end

function Placement_begin_timed_action(num_frames, complete_fn, ...)
    if(not Settings_60fps) num_frames /= 2
    -- Is there a place already in progress?
    if Placement_progress != nil then
        return
    end
    local fn_args = {...}
    Placement_placing_coroutine = CoroutineRunner_StartScript(function ()
        for frame_num=1,num_frames do
            if(Character_is_moving) then
                Placement_cancel_timed_action() -- Cancel the operation if the player moves
                return
            end
            Placement_progress = frame_num/num_frames
            yield()
        end
        complete_fn(unpack(fn_args))
        Placement_progress = nil
    end)
end

function Placement_complete_place(ent_id, x, y)
    if not Inventory_check_and_remove(ent_id) then
        assert(false) -- Place failed inventory check
    end
    local fn = Placement_placement_fns[ent_id]
    if fn then
        fn(x, y)
    else
        Locations_place_entity(ent_id, x, y)
    end

    if Inventory_get(ent_id) == 0 then
        -- That was our last one, rotate off it, skipping None since rotating to None would be weird
        Placement_rotate_with_inventory_check(true, true)
    end
    Circuits_recalculate()
    shake_screen()
end

function Placement_custom_action(ent_id, x, y)
    Attr_action_fn[ent_id](ent_id, x, y)
    -- The custom action may have modified our inventory
    if(Placement_placeable_index == nil or Inventory_get(Placement_placeable_index) == 0) Placement_rotate_with_inventory_check(true, true)
end

function Placement_determine_action_and_sprite(entity_at_sel)
    -- returns action, action_ent, sprite
    if entity_at_sel == nil then
        if Placement_current_action == Actions_pick_up then
            -- If we have nothing selected, but we're removing, we take no action but retain the pick_up sprite.
            return Actions_no_action, nil, Sprite_id_pick_up
        elseif Placement_current_action == Actions_no_action or Placement_current_action == Actions_place then
            -- Placing

            -- Are there any smooth entities in the way?
            -- This is not World.is_obstructed because we already know there isn't a Locations entity obstructing
            if SmoothLocations_is_obstructed(Placement_sel_x, Placement_sel_y) then
                return Actions_no_action, nil, Sprite_id_no_action
            end

            -- What are we placing?

            local place_ent_id = Placement_get_place_ent_id()
            if not place_ent_id then
                -- Nothing to place
                return Actions_no_action, nil, Sprite_id_no_action
            end

            -- Does the thing we're placing think this location is obstructed?
            local fn = Placement_obstructed_fns[place_ent_id]
            if fn and fn(Placement_sel_x, Placement_sel_y) then
                return Actions_no_action, nil, Sprite_id_no_action
            end
            -- We're not removing and we have nothing selected, so we're placing the user's selected item.
            return Actions_place, place_ent_id, Attr_mini_sprite[place_ent_id]
        end
    end

    -- We have something selected

    -- Is it a custom actionable entity?
    if Placement_current_action == Actions_no_action then
        if Attr_action_fn[entity_at_sel] then
            -- Is it in range for that action?
            local char_x, char_y = SmoothLocations_get_location(Entities_Character)
            local adist = Attr_action_mindist[entity_at_sel]
            if adist == nil or dist(char_x, char_y, Placement_sel_x, Placement_sel_y) <= adist then
                return Actions_custom, entity_at_sel, Attr_mini_sprite[entity_at_sel]
            end
        end
    end

    if Placement_current_action == Actions_custom then
        -- We already started a custom action.  Don't trigger it again, but continue to display its sprite
        return Actions_no_action, nil, Placement_sel_sprite
    end

    -- If we're placing the currently selected item
    if Placement_current_action == Actions_place and Placement_current_action_ent == entity_at_sel then
        -- We can't re-place an item, but we let the user know we're still placing.
        return Actions_no_action, nil, Placement_sel_sprite
    end

    -- If we're removing the currently selected item, pick it up.
    -- Note this will only happen for 1 frame because the item will be removed this frame
    if Placement_current_action == Actions_pick_up and Placement_current_action_ent == entity_at_sel then
        return Actions_pick_up, entity_at_sel, Sprite_id_pick_up
    end

    -- If we're not placing or removing, and we have something pick-uppable selected, pick it up.
    if Placement_current_action == Actions_no_action and Attr_removable[entity_at_sel] then
        return Actions_pick_up, entity_at_sel, Sprite_id_pick_up
    end

    -- No valid action was found.
    return Actions_no_action, nil, Sprite_id_no_action
end

function limit_to(val, min, max)
    if val < min then
        return -1, min
    elseif val > max then
        return 1, max
    end
    return 0, val
end

function Placement_handle_character_movement(is_first_movement_frame, elapsed, xv, yv)
    -- Takes in the user's requested movement vector.
    -- Moves the selection box first, then both box and character once it reaches max range.
    -- Returns the character's modified movement vector.

    local char_x, char_y = SmoothLocations_get_location(Entities_Character)
    local new_xv = xv
    local new_yv = yv

    -- If we're not using placement, don't change anything.  Just keep the selection box nearby
    if(Placement_get_place_ent_id() == Entities_None) then
        if(xv != 0 or yv != 0) then
            Placement_sel_x_p = char_x + 0.5 + (xv*1.5)
            Placement_sel_y_p = char_y + 0.5 + (yv*1.5)
        end
    else
        -- Is it the first movement frame?
        if is_first_movement_frame then
            -- If it's the first movement frame, we want to kickstart the movement, but not too far so we don't jump twice.
            -- This is so a single-frame tap will always move the selection box, for responsiveness.
            xv=xv/2
            yv=yv/2
        else
            -- Then for subsequent frames, we normalize the movement speed to the frame rate.
            xv, yv = normalize(xv, yv, Settings_selection_speed*elapsed)
        end

        -- If we're at the max selection range, move the character

        new_xv, Placement_sel_x_p = limit_to(Placement_sel_x_p + xv, char_x - Settings_max_selection_range, char_x + Settings_max_selection_range)
        new_yv, Placement_sel_y_p = limit_to(Placement_sel_y_p + yv, char_y - Settings_max_selection_range, char_y + Settings_max_selection_range)
    end

    local old_sel_x, old_sel_y = Placement_sel_x, Placement_sel_y
    Placement_sel_x = flr(Placement_sel_x_p)
    Placement_sel_y = flr(Placement_sel_y_p)
    if(old_sel_x != Placement_sel_x) animate_movement(function (val) Placement_sel_x_visual = val end, old_sel_x, Placement_sel_x, 5, easeinquadoutelastic)
    if(old_sel_y != Placement_sel_y) animate_movement(function (val) Placement_sel_y_visual = val end, old_sel_y, Placement_sel_y, 5, easeinquadoutelastic)
    if(Placement_get_place_ent_id() != Entities_None and (old_sel_x != Placement_sel_x or old_sel_y != Placement_sel_y)) sfx(SFX_id_move_placement)

    return new_xv, new_yv
end
