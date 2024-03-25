
-- todo
-- add total electricity generated
-- add energy storage
-- add day/night cycle
-- add panel inventory
-- add money to buy panels
-- add store to buy panels from
-- add trees
-- add houses?

function draw_selection(char)
    Sprites.draw_spr("selection_box",Placement.sel_x,Placement.sel_y)
    Sprites.draw_spr(Placement.sel_sprite,Placement.sel_x,Placement.sel_y-1)
end

function _init()
    srand(12345)

    Rocks.create_rocks()
    Panels.init()
    Wire.init()
    Transformers.init()
end

function _draw()
    cls()
    map(0,0,64-(Character.x*8),64-(Character.y*8))

    Drawable.draw_all(Character.x, Character.y)

    Character.draw(64, 64)
    draw_selection(Character)
end

function _update60()
    local elapsed = FrameTimer.calculate_elapsed()
    handle_player_movement(elapsed)
    handle_selection_and_placement()
end

-- Convenience method
function obstructed(x, y)
    return Attributes.get_attr_by_location(x, y, "WalkingObstruction")
end

function handle_player_movement(elapsed)

    -- Check for player movement
    local x=0
    local y=0
    local is_moving = false
    if btn(⬅️) then
        Character.flip_x=true
        Character.anim_frames={1,2}
        x=-1
        is_moving = true
    end
    if btn(➡️) then
        Character.anim_frames={1,2}
        Character.flip_x=false
        x=1
        is_moving = true
    end
    if btn(⬆️) then
        Character.anim_frames={3,4}
        y=-1
        is_moving = true
        if btn(⬅️) or btn(➡️) then
            Character.anim_frames={9,10}
        end
    end
    if btn(⬇️) then
        Character.anim_frames={7,8}
        y=1
        is_moving = true
        if btn(⬅️) or btn(➡️) then
            Character.anim_frames={5,6}
        end
    end

    -- Calculate if it's the first movement frame or not
    is_first_movement_frame = false
    if is_moving and not Character.is_moving then
        is_first_movement_frame = true
    end
    Character.is_moving = is_moving

    -- Process player movement

    max_sel_range=2
    sel_speed = 12

    -- Is it the first movement frame?
    if is_first_movement_frame then
        -- If it's the first movement frame, we want to kickstart the movement, but not too far so we don't jump twice.
        -- This is so a single-frame tap will always move the selection box, for responsiveness.
        x=x/2
        y=y/2
    else
        -- Then for subsequent frames, we normalize the movement speed to the frame rate.
        x, y = normalize(x, y, sel_speed*elapsed)
    end
    Placement.sel_x_p += x
    Placement.sel_y_p += y

    -- If we're at the max selection range, move the character
    char_x = 0
    char_y = 0
    if Placement.sel_x_p > Character.x + max_sel_range + .5 then
        char_x = 1
        Placement.sel_x_p = Character.x + max_sel_range + .5
    elseif Placement.sel_x_p < Character.x - max_sel_range + .5 then
        char_x = -1
        Placement.sel_x_p = Character.x - max_sel_range + .5
    end
    if Placement.sel_y_p > Character.y + max_sel_range + .5 then
        char_y = 1
        Placement.sel_y_p = Character.y + max_sel_range + .5
    elseif Placement.sel_y_p < Character.y - max_sel_range + .5 then
        char_y = -1
        Placement.sel_y_p = Character.y - max_sel_range + .5
    end
    char_x, char_y = normalize(char_x, char_y, Character.speed*elapsed)
    Placement.sel_x = flr(Placement.sel_x_p)
    Placement.sel_y = flr(Placement.sel_y_p)
    -- The player can't walk through panels
    if not obstructed(flr(Character.x+char_x+.6), flr(Character.y+1)) then
        Character.x += char_x
    end
    if not obstructed(flr(Character.x+.6), flr(Character.y+char_y+1)) then
        Character.y += char_y
    end
    -- Animate walking
    if char_x!=0 or char_y!=0 then
        Character.frame += Character.anim_speed*elapsed
    else
        Character.frame = 0.99 -- Very close to the next frame to increase responsivenes
    end
end

function determine_sprite(entity_at_sel, selected_type, action)
    local sprite_from_entid = {
        [Panels.ent_id] = "place_panel",
        [Wire.ent_id] = "place_wire",
    }

    local sprites_from_action = {
        no_action = "no_action",
        pick_up_panel = "pick_up",
        pick_up_wire = "pick_up",
        place_panel = "place_panel",
        place_wire = "place_wire",
    }

    if entity_at_sel != nil and entity_at_sel == Character.is_placing then
        return sprite_from_entid[entity_at_sel]
    end

    if Character.is_removing then
        if entity_at_sel != nil then
            return "no_action"
        end
        return "pick_up"
    end

    return sprites_from_action[action]
end

function handle_selection_and_placement()
    Placement.set_place_mode(btnp(🅾️))

    -- Determine what we have selected
    local entity_at_sel = Locations.entity_at(Placement.sel_x, Placement.sel_y) -- may be nil

    local selected_type = ObjectTypes.type_of(entity_at_sel) -- TODO this shouldn't be needed since entity id is good enough <-- is that true?

    -- 1. determine action -- no action, pick up panel, pick up wire, place panel, place wire
    action = determine_action(selected_type)

    -- 2. determine sprite
    Placement.sel_sprite = determine_sprite(entity_at_sel, selected_type, action)

    -- 3. take action if button pressed, and set placement/removal state

    -- TODO keep refactoring this until we don't need string action flags

    local function remove(ent_id, mode, x, y)
        Character.is_removing = ent_id
        Placement.place_mode = mode
        Locations.remove_entity(x, y)
    end

    local function place(ent_id, x, y)
        Character.is_placing = ent_id
        if ent_id == Panels.ent_id then
            Placement.place_mode = "place_panel"
        elseif ent_id == Wire.ent_id then
            Placement.place_mode = "place_wire"
        end
        Locations.place_entity(ent_id, Placement.sel_x, Placement.sel_y)
    end

    if btn(❎) then
        if action == "no_action" then
            -- pass
        elseif action == "pick_up_panel" then
            remove(Panels.ent_id, "place_panel", Placement.sel_x, Placement.sel_y)
        elseif action == "pick_up_wire" then
            remove(Wire.ent_id, "place_wire", Placement.sel_x, Placement.sel_y)
        elseif action == "place_panel" then
            place(Panels.ent_id, Placement.sel_x, Placement.sel_y)
        elseif action == "place_wire" then
            place(Wire.ent_id, Placement.sel_x, Placement.sel_y)
        else
            assert(false) -- unknown action
        end
    else
        Character.is_placing = nil
        Character.is_removing = nil
    end
end

-- Define a table mapping item types to their actions
local action_map = {
    panel = {
        place_action = "place_panel",  -- action when placing this item
        pick_up_action = "pick_up_panel",  -- action when picking up this item
    },
    wire = {
        place_action = "place_wire",
        pick_up_action = "pick_up_wire",
    },
}

function determine_action(selected_type)
    local action = "no_action"  -- Default action

    if Character.is_placing then
        if selected_type == nil then
            -- We're in place mode but haven't selected a type; use the user's selected mode.
            action = Placement.place_mode
        end
    elseif Character.is_removing then
        -- Check if the selected type has a mapped action for removing
        if action_map[selected_type] and action_map[selected_type].pick_up_action then
            action = action_map[selected_type].pick_up_action
        end
    else
        -- Not placing or removing; check if we should pick up an item
        if selected_type and action_map[selected_type] and action_map[selected_type].pick_up_action then
            action = action_map[selected_type].pick_up_action
        elseif selected_type == nil then
            -- If nothing's there, we're in place mode; use the user's selected mode.
            action = Placement.place_mode
        end
    end

    return action
end
