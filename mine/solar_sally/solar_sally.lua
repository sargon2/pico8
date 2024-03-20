
-- todo
-- the selection box is a bit awkward.
-- make it further away, but still
-- not pass through the nearest
-- panel.
-- also if you go down, then right, it shouldn't
-- jump so far...
-- turn off key repeat by reimplementing
-- btnp
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
}

panel_locations={
    [10]={[10]=true,[11]=true,[15]=true,[20]=true},
    [11]={[10]=true,[11]=true,[16]=true,[19]=true},
    [20]={[10]=true,[11]=true},
}

last_t=0

function draw_char(char,x,y)
    local f=char.anim_frames[
        1+(flr(char.frame) % #char.anim_frames)
    ]
    spr(f,x,y,1,1,char.flip_x)
end

function draw_selected(char)
    draw_spr(32,char.sel_x,char.sel_y)
end

function _init()
end

function _draw()
    cls()
    map(0,0,64-(char.x*8),64-(char.y*8))
    draw_panels()
    draw_char(char, 64, 64)
    draw_selected(char)
end

function draw_spr(s,x,y)
    spr(
        s,
        (8+x-char.x)*8,
        (8+y-char.y)*8
    )
end

function panel_at(x,y)
    xp = panel_locations[x]
    return xp and xp[y]
end

function draw_panels()
    overlays={}
    for x,ys in pairs(panel_locations) do
        for y,t in pairs(ys) do
            -- draw overlays
            -- careful about leg length
            if panel_at(x+1,y+1) then
                if not overlays[x] then
                    overlays[x] = {}
                end
                -- short legs override long
                if not overlays[x][y] then
                    if panel_at(x,y+1) then
                        overlays[x][y]=2
                    else
                        overlays[x][y]=1
                    end
                end
            end
            if panel_at(x+1,y-1) then
                if not overlays[x] then
                    overlays[x] = {}
                end
                overlays[x][y-1]=2
            end
            draw_spr(17,x,y)
        end
    end
    for x,row in pairs(overlays) do
        for y,v in pairs(row) do
            draw_spr(21,x,y)
            draw_spr(38,x+1,y+1)
            draw_spr(22,x+1,y)
            if v==1 then
                draw_spr(37,x,y+1) -- long leg
            else
                draw_spr(53,x,y+1) -- short leg
            end
        end
    end
end

function bound(val, min, max)
    if val < min then
        return min
    elseif val > max then
        return max
    end
    return val
end

function _update60()

    -- Handle physics advancement timing
    ft=t()
    elapsed=ft-last_t
    last_t=ft
    max_skip_fps=15
    max_elapsed=1/max_skip_fps
    if elapsed>max_elapsed then
        -- make sure we don't skip physics too far if the game hiccups
        elapsed=max_elapsed
    end

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
    if not panel_at(
        flr(char.x+char_x+.6),
        flr(char.y+1)
    ) then
        char.x += char_x
    end
    if not panel_at(
        flr(char.x+.6),
        flr(char.y+char_y+1)
    ) then
        char.y += char_y
    end
    -- Animate walking
    if char_x!=0 or char_y!=0 then
        char.frame += char.anim_speed*elapsed
    else
        char.frame = 0.99 -- TODO ?? why is this .99?
    end

    -- Handle panel removal/placement

    if btn(❎) then
        if not panel_locations[char.sel_x] then
            panel_locations[char.sel_x] = {}
        end
        if not char.is_placing and not char.is_removing then
            -- first press frame, determine if we're placing or removing
            if panel_locations[char.sel_x][char.sel_y] then
                char.is_removing = true
            else
                char.is_placing = true
            end
        end
        if char.is_placing then
            panel_locations[char.sel_x][char.sel_y] = true
        elseif char.is_removing then
            panel_locations[char.sel_x][char.sel_y] = nil
        end
    else
        char.is_placing = false
        char.is_removing = false
    end
end
