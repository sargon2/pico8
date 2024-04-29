Character = {
    name = "Character",
    frame=1,
    speed=6,
    anim_speed=8,
    anim_frames={1,2},
    flip_x=false,
    is_moving = false,
}

function Character.init()
    SmoothLocations_set_or_update_location(Entities_Character, 0, 0)
    Attr_DrawFn[Entities_Character] = Character.drawChar
end

function Character.update(elapsed)
    Character.handle_player_movement(elapsed)
end

function Character.drawChar()
    local f=Character.anim_frames[
        1+(flr(Character.frame) % #Character.anim_frames)
    ]
    spr(f,64,64,1,1,Character.flip_x)
end

function Character.handle_player_movement(elapsed)

    -- Check for player movement
    local x=0
    local y=0
    local is_moving = false
    if my_btn(⬅️) then
        Character.flip_x=true
        Character.anim_frames={1,2}
        x=-1
        is_moving = true
    end
    if my_btn(➡️) then
        Character.anim_frames={1,2}
        Character.flip_x=false
        x=1
        is_moving = true
    end
    if my_btn(⬆️) then
        Character.anim_frames={3,4}
        y=-1
        is_moving = true
        if my_btn(⬅️) or my_btn(➡️) then
            Character.anim_frames={9,10}
        end
    end
    if my_btn(⬇️) then
        Character.anim_frames={7,8}
        y=1
        is_moving = true
        if my_btn(⬅️) or my_btn(➡️) then
            Character.anim_frames={5,6}
        end
    end

    -- Calculate if it's the first movement frame or not
    local is_first_movement_frame = false
    if is_moving and not Character.is_moving then
        is_first_movement_frame = true
    end
    Character.is_moving = is_moving

    -- Process player movement
    if system_is_loaded(Placement) then
        x, y = Placement_handle_character_movement(is_first_movement_frame, elapsed, x, y)
    end

    SmoothLocations_move_by_if_not_obstructed(Entities_Character, x, y, Character.speed*elapsed)

    -- Animate walking
    if x!=0 or y!=0 then
        Character.frame += Character.anim_speed*elapsed
    else
        Character.frame = 0.99 -- Very close to the next frame to increase responsivenes
    end
end
