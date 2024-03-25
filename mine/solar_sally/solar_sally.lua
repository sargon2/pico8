
-- todo
-- add total electricity generated
-- add energy storage
-- add day/night cycle
-- add panel inventory
-- add money to buy panels
-- add store to buy panels from
-- add trees
-- add houses?

char = {
    x=0,
    y=0,
    frame=1,
    speed=6,
    anim_speed=8,
    anim_frames={1,2},
    flip_x=false,
    -- selected square
    sel_x_p=0, -- "precise" (sub-integer)
    sel_y_p=0,
    sel_x=0,
    sel_y=0,
    is_moving = false,
    is_placing = false,
    is_removing = false,
    sel_sprite = "no_action",
    place_mode = "place_panel",
}

function draw_char(char,x,y)
    local f=char.anim_frames[
        1+(flr(char.frame) % #char.anim_frames)
    ]
    spr(f,x,y,1,1,char.flip_x)
end

function draw_selection(char)
    Sprites.draw_spr("selection_box",char.sel_x,char.sel_y)
    Sprites.draw_spr(char.sel_sprite,char.sel_x,char.sel_y-1)
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
    map(0,0,64-(char.x*8),64-(char.y*8))

    Drawable.draw_all(char.x, char.y)

    draw_char(char, 64, 64)
    draw_selection(char)
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
        char.flip_x=true
        char.anim_frames={1,2}
        x=-1
        is_moving = true
    end
    if btn(➡️) then
        char.anim_frames={1,2}
        char.flip_x=false
        x=1
        is_moving = true
    end
    if btn(⬆️) then
        char.anim_frames={3,4}
        y=-1
        is_moving = true
        if btn(⬅️) or btn(➡️) then
            char.anim_frames={9,10}
        end
    end
    if btn(⬇️) then
        char.anim_frames={7,8}
        y=1
        is_moving = true
        if btn(⬅️) or btn(➡️) then
            char.anim_frames={5,6}
        end
    end

    -- Calculate if it's the first movement frame or not
    is_first_movement_frame = false
    if is_moving and not char.is_moving then
        is_first_movement_frame = true
    end
    char.is_moving = is_moving

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
        x, y = normalize(x, y, sel_speed*elapsed) -- TODO vector type instead of tuple?
    end
    char.sel_x_p += x
    char.sel_y_p += y

    -- If we're at the max selection range, move the character
    char_x = 0
    char_y = 0
    if char.sel_x_p > char.x + max_sel_range + .5 then
        char_x = 1
        char.sel_x_p = char.x + max_sel_range + .5
    elseif char.sel_x_p < char.x - max_sel_range + .5 then
        char_x = -1
        char.sel_x_p = char.x - max_sel_range + .5
    end
    if char.sel_y_p > char.y + max_sel_range + .5 then
        char_y = 1
        char.sel_y_p = char.y + max_sel_range + .5
    elseif char.sel_y_p < char.y - max_sel_range + .5 then
        char_y = -1
        char.sel_y_p = char.y - max_sel_range + .5
    end
    char_x, char_y = normalize(char_x, char_y, char.speed*elapsed)
    char.sel_x = flr(char.sel_x_p)
    char.sel_y = flr(char.sel_y_p)
    -- The player can't walk through panels
    if not obstructed(flr(char.x+char_x+.6), flr(char.y+1)) then
        char.x += char_x
    end
    if not obstructed(flr(char.x+.6), flr(char.y+char_y+1)) then
        char.y += char_y
    end
    -- Animate walking
    if char_x!=0 or char_y!=0 then
        char.frame += char.anim_speed*elapsed
    else
        char.frame = 0.99 -- TODO ?? why is this .99?
    end
end

function set_place_mode()
    if btnp(🅾️) then
        if char.place_mode == "place_panel" then
            char.place_mode = "place_wire"
        else
            char.place_mode = "place_panel"
        end
    end
end

function determine_sprite_from_action(action)
    local sprites_from_action = {
        no_action = "no_action",
        pick_up_panel = "pick_up",
        pick_up_wire = "pick_up",
        place_panel = "place_panel",
        place_wire = "place_wire",
    }
    return sprites_from_action[action]
end

function handle_selection_and_placement()
    set_place_mode()

    -- Determine what we have selected
    local entity_at_sel = Locations.entity_at(char.sel_x, char.sel_y) -- may be nil

    local selected_type = ObjectTypes.type_of(entity_at_sel)

    -- 1. determine action -- no action, pick up panel, pick up wire, place panel, place wire
    action = determine_action(selected_type)

    -- 2. determine sprite from action
    -- TODO when we're removing, we shouldn't get the "x" selection icon unless we're hovering over a non-removable item
    -- TODO same for placing, we shouldn't get the "x" directly after placing something
    char.sel_sprite = determine_sprite_from_action(action)

    -- 3. take action if button pressed, and set placement/removal state
    if btn(❎) then
        -- TODO convert this to a table of lambda functions?
        if action == "no_action" then
            -- pass
        elseif action == "pick_up_panel" then
            char.is_removing = true
            char.place_mode = "place_panel"
            Locations.remove_entity(char.sel_x, char.sel_y)
        elseif action == "pick_up_wire" then
            char.is_removing = true
            char.place_mode = "place_wire"
            Locations.remove_entity(char.sel_x, char.sel_y)
        elseif action == "place_panel" then
            char.is_placing = true
            char.place_mode = "place_panel"
            Panels.place_panel_at(char.sel_x, char.sel_y)
        elseif action == "place_wire" then
            char.is_placing = true
            char.place_mode = "place_wire"
            Wire.place_wire_at(char.sel_x, char.sel_y)
        else
            assert(false) -- unknown action
        end
    else
        char.is_placing = false
        char.is_removing = false
    end
end

function determine_action(selected_type)
    local action

    -- If we're placing, then we place on empty, and everything else is no_action.
    -- If we're removing, then we remove panels/wire, and everything else is no_action.
    -- If we're not placing or removing, action depends on entity.
    -- This is fizzbuzz.

    -- TODO refactor this so we don't hardcode panel/wire -- we should have a map like "panel" -> "pick_up_panel" etc.

    if char.is_placing then
        if selected_type == nil then
            action = char.place_mode
        else
            action = "no_action"
        end
    elseif char.is_removing then
        if char.place_mode == "place_panel" then
            if selected_type == "panel" then
                action = "pick_up_panel"
            else
                action = "no_action"
            end
        elseif char.place_mode == "place_wire" then
            if selected_type == "wire" then
                action = "pick_up_wire"
            else
                action = "no_action"
            end
        else
            assert(false) -- Unknown place mode
        end
    else
        -- we're not currently placing or removing
        if selected_type == "panel" then
            action = "pick_up_panel"
        elseif selected_type == "wire" then
            action = "pick_up_wire"
        elseif selected_type == nil then
            -- If nothing's there, we're in place mode, and we use the user's selected mode.
            action = char.place_mode
        else
            -- something's there, but it's not a removable type
            action = "no_action"
        end
    end

    return action
end
