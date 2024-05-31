Actions = {}

--[[const]] Actions_no_action = 1
--[[const]] Actions_place_panel = 2
--[[const]] Actions_place_wire = 3
--[[const]] Actions_place_transformer = 4
--[[const]] Actions_place_fence = 5
--[[const]] Actions_pick_up = 6
--[[const]] Actions_axe = 7
--[[const]] Actions_press_button = 8
--[[const]] num_actions = 8

local action_coroutine

local Attr_action_cancel_fn, Attr_action_start_fn, Attr_action_mini_sprite

local action_sel_x_p, action_sel_y_p, action_sel_x, action_sel_y, action_sel_x_visual, action_sel_y_visual = 0, 0, 0, 0, 0, 0

local action_executing = false
local action_progress = nil -- for display
local last_action_button_state = false -- whether or not the action button was depressed last frame

local selected_action = Actions_no_action

function Actions.on_load()
    -- Indexed by action id
    Attr_action_cancel_fn = { noop, cancel_placing, cancel_placing, cancel_placing, cancel_placing, noop, Axe_end_action, Button_stop_action }
    Attr_action_start_fn = { noop, start_placing, start_placing, start_placing, start_placing, start_removing, Axe_begin_action, Button_start_action }
    Attr_action_mini_sprite = {
        Sprite_id_no_action,
        Sprite_id_place_panel,
        Sprite_id_place_wire,
        Sprite_id_place_transformer,
        Sprite_id_fence_mini,
        Sprite_id_pick_up,
        Sprite_id_mini_axe,
        Sprite_id_button_mini
    }
end

function Actions.on_enable()
    selected_action = Actions_no_action -- Default to turned off
end

function Actions_start_timed_action(completion_fn, num_frames, ent_id, x, y)
    if(not Settings_60fps) num_frames /= 2

    action_coroutine = CoroutineRunner_StartScript(function ()
        for frame_num=1,num_frames do
            if(Character_or_action_moving) then
                Actions_cancel() -- Cancel the operation if the player moves
                return
            end
            Actions_update_progress(frame_num/num_frames)
            yield()
        end
        completion_fn(ent_id, x, y)
        Actions_update_progress()
    end)
end

function Actions_cancel() -- Cancel any action in progress
    CoroutineRunner_Cancel(action_coroutine)
    if action_executing then
        Attr_action_cancel_fn[selected_action](selected_action)
        action_progress = nil
    end
end

function Actions_rotate()
    -- Rotate selected action: off -> all possible actions -> off.  Doesn't check inventory.  Skips items the player doesn't know exist yet.
    local started_on_none = (selected_action == Actions_no_action)

    selected_action %= num_actions
    selected_action += 1

    if not system_is_running(Axe) and selected_action == Actions_axe then -- Skip axe if the player doesn't have it yet
        return Actions_rotate()
    end

    if not Inventory_has_fence() and selected_action == Actions_place_fence then
        return Actions_rotate()
    end

    if started_on_none then
        sfx(SFX_id_activate_actions)
    elseif selected_action == Actions_no_action then
        sfx(SFX_id_deactivate_actions)
    else
        sfx(SFX_id_rotate_action)
    end
end

function Actions_update_progress(progress) -- 0->1
    action_progress = progress
    if(progress == nil) action_executing = false
end

function Actions.draw()
    if(selected_action == Actions_no_action) return
    Sprites_draw_spr(Sprite_id_selection_box, action_sel_x_visual, action_sel_y_visual)
    Sprites_draw_spr(Attr_action_mini_sprite[selected_action], action_sel_x_visual, action_sel_y_visual-1)

    -- Progress indicator
    if(action_progress != nil) then
        Sprites_draw_line(
            action_sel_x_visual,
            action_sel_y_visual+1,
            lerp(action_sel_x_visual, action_sel_x_visual+(7/8), action_progress),
            action_sel_y_visual+1,
            11
        )
    end
end

function Actions.update()
    if my_btnp(Button_select_action) then
        Actions_rotate()
    end

    local action_btn_state = my_btn(Button_take_action)

    -- Start or stop an action
    if action_btn_state and not last_action_button_state then
        action_executing = Attr_action_start_fn[selected_action](selected_action, action_sel_x, action_sel_y)
    elseif action_executing and last_action_button_state and not action_btn_state then
        Actions_cancel()
    end
    last_action_button_state = action_btn_state
end

function Actions_handle_character_movement(is_first_movement_frame, elapsed, xv, yv)
    -- Takes in the user's requested movement vector.
    -- Moves the selection box first, then both box and character once it reaches max range.
    -- Returns the character's modified movement vector.

    local char_x, char_y = SmoothLocations_get_location(Entities_Character)
    local new_xv = xv
    local new_yv = yv

    -- If we're not using actions, don't change anything.  Just keep the selection box nearby
    if(selected_action == Actions_no_action) then
        if(xv != 0 or yv != 0) then
            action_sel_x_p = char_x + 0.5 + (xv*1.5)
            action_sel_y_p = char_y + 0.5 + (yv*1.5)
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

        new_xv, action_sel_x_p = limit_to(action_sel_x_p + xv, char_x - Settings_max_selection_range, char_x + Settings_max_selection_range)
        new_yv, action_sel_y_p = limit_to(action_sel_y_p + yv, char_y - Settings_max_selection_range, char_y + Settings_max_selection_range)
    end

    local old_sel_x, old_sel_y = action_sel_x, action_sel_y
    action_sel_x = flr(action_sel_x_p)
    action_sel_y = flr(action_sel_y_p)
    if(old_sel_x != action_sel_x) animate_movement(function (val) action_sel_x_visual = val end, old_sel_x, action_sel_x, 5)
    if(old_sel_y != action_sel_y) animate_movement(function (val) action_sel_y_visual = val end, old_sel_y, action_sel_y, 5)
    if(selected_action != Actions_no_action and (old_sel_x != action_sel_x or old_sel_y != action_sel_y)) sfx(SFX_id_move_action)

    return new_xv, new_yv
end

function Actions_draw_selection_box(x, y, width, height, relative_to_screen)
    -- This function is an alternative to the 1x1 Sprite_id_selection_box for selecting larger things.
    -- It takes about 0.64% of a 60fps frame budget to run.  Drawing 1 sprite takes about 0.23%.

    -- These functions just reduce the token count.
    local function draw_yellow(xp, yp, xoff, yoff)
        Sprites_set_pixel(xp, yp, xoff, yoff, 10, relative_to_screen)
    end

    local function set3(xp, yp, x1, x2, y1, y2)
        -- color 10 is yellow
        draw_yellow(xp, yp, x1, y1)
        draw_yellow(xp, yp, x1, y2)
        draw_yellow(xp, yp, x2, y1)
    end

    set3(x, y, 0, 1, 0, 1) -- Upper left
    set3(x+width-1, y, 7, 6, 0, 1) -- Upper right
    set3(x, y+height-1, 0, 1, 7, 6) -- Lower left
    set3(x+width-1, y+height-1, 7, 6, 7, 6) -- Lower right
end
