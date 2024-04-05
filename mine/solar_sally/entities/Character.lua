Character = {
    ent_id = nil,
    x=0,
    y=0,
    frame=1,
    speed=6,
    anim_speed=8,
    anim_frames={1,2},
    flip_x=false,
    is_moving = false,
}

function Character.init()
    Character.ent_id = Entities.create_entity()
end

function Character.get_name()
    return "Character"
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

function Character._obstructed(x, y)
    return Attributes.get_attr_by_location(x, y, "WalkingObstruction")
end

function Character.handle_player_movement(elapsed)

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
    if not Character._obstructed(flr(Character.x+char_x+.6), flr(Character.y+1)) then
        Character.x += char_x
    end
    if not Character._obstructed(flr(Character.x+.6), flr(Character.y+char_y+1)) then
        Character.y += char_y
    end
    -- Animate walking
    if char_x!=0 or char_y!=0 then
        Character.frame += Character.anim_speed*elapsed
    else
        Character.frame = 0.99 -- Very close to the next frame to increase responsivenes
    end
end

