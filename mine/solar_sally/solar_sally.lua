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
    sel_x=0, -- selected square
    sel_y=0,
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

function _update60()
    ft=t()
    elapsed=ft-last_t
    last_t=ft
    sel_x=0
    sel_y=0
    max_skip_fps=15
    max_elapsed=1/max_skip_fps
    if elapsed>max_elapsed then
        -- make sure we don't skip
        -- physics too far if the
        -- game hiccups
        elapsed=max_elapsed
    end
    local x=0
    local y=0
    if btn(⬅️) then
        char.flip_x=true
        char.anim_frames={1,2}
        x=-1
        sel_x=-.5
    end
    if btn(➡️) then
        char.anim_frames={1,2}
        char.flip_x=false
        x=1
        sel_x=1
    end
    if btn(⬆️) then
        char.anim_frames={3,4}
        y=-1
        sel_y=-.5
        if btn(⬅️) or btn(➡️) then
            char.anim_frames={9,10}
        end
    end
    if btn(⬇️) then
        char.anim_frames={7,8}
        y=1
        sel_y=1
        if btn(⬅️) or btn(➡️) then
            char.anim_frames={5,6}
        end
    end
    if x!=0 or y!=0 then
        -- normalize the movement vector
        local len=sqrt(x^2+y^2)
        x/=len
        y/=len
        x*=char.speed*elapsed
        y*=char.speed*elapsed
        if not panel_at(
            flr(char.x+x+.6),
            flr(char.y+1)
        ) then
            char.x += x
        end
        if not panel_at(
            flr(char.x+.6),
            flr(char.y+y+1)
        ) then
            char.y += y
        end
    end
    if x!=0 or y!=0 then
        char.frame += char.anim_speed*elapsed
    else
        char.frame = 0.99
    end
    if sel_x!=0 or sel_y!=0 then
        char.sel_x=flr(sel_x+char.x+.5) -- todo
        char.sel_y=flr(sel_y+char.y+.5)
    end
    if btnp(❎) then
        -- todo no key repeat
        if not panel_locations[char.sel_x] then
            panel_locations[char.sel_x] = {}
        end
        if panel_locations[char.sel_x][char.sel_y] then
            panel_locations[char.sel_x][char.sel_y] = nil
        else
            panel_locations[char.sel_x][char.sel_y] = true
        end
    end
end
