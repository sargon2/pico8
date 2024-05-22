Character = {}

local Character_frame=1
local Character_anim_frames={1,2}
Character_flip_x=false
Character_or_placement_moving = false
local Character_footstep_sfx_loop = nil

function Character.on_load()
    SmoothLocations_set_or_update_location(Entities_Character, 0, 0)
    Attr_DrawFn[Entities_Character] = Character_drawChar
end

function Character.update(elapsed)
    Character_handle_player_movement(elapsed)
end

function Character_drawChar(x, y, ent_id, relative_to_screen)
    local f
    if Character.temp_frame then
        f = Character.temp_frame
    else
        -- Normal walking animations
        f=Character_anim_frames[
            1+(flr(Character_frame) % #Character_anim_frames)
        ]
    end
    Sprites_draw_spr(f, x, y, 1, 1, Character_flip_x, relative_to_screen)
end

function Character_set_temp_frame(f)
    Character.temp_frame = f
end

function Character_handle_player_movement(elapsed)

    -- Check for player movement
    local x=0
    local y=0
    local is_moving = false
    if my_btn(⬅️) then
        Character_flip_x=true
        Character_anim_frames={1,2}
        x=-1
        is_moving = true
    end
    if my_btn(➡️) then
        Character_anim_frames={1,2}
        Character_flip_x=false
        x=1
        is_moving = true
    end
    if my_btn(⬆️) then
        Character_anim_frames={3,4}
        y=-1
        is_moving = true
        if my_btn(⬅️) or my_btn(➡️) then
            Character_anim_frames={9,10}
        end
    end
    if my_btn(⬇️) then
        Character_anim_frames={7,8}
        y=1
        is_moving = true
        if my_btn(⬅️) or my_btn(➡️) then
            Character_anim_frames={5,6}
        end
    end

    -- Calculate if it's the first movement frame or not
    local is_first_movement_frame = false
    if is_moving and not Character_or_placement_moving then
        is_first_movement_frame = true
    end
    Character_or_placement_moving = is_moving

    -- Process player movement
    if system_is_running(Placement) then
        x, y = Placement_handle_character_movement(is_first_movement_frame, elapsed, x, y)
    end

    -- Perform & animate walking
    if x != 0 or y != 0 then -- if the character herself is moving, not just the selection box
        if(Character_footstep_sfx_loop == nil) Character_footstep_sfx_loop = start_sfx_loop(SFX_id_footsteps, Settings_footstep_sfx_loop_speed)
        SmoothLocations_move_by_if_not_obstructed(Entities_Character, x, y, Settings_character_speed*elapsed)
        Character_frame += Settings_character_anim_speed*elapsed
    else
        Character_frame = 0.99 -- Very close to the next frame to increase responsivenes
        CoroutineRunner_Cancel(Character_footstep_sfx_loop)
        Character_footstep_sfx_loop = nil
    end
end
