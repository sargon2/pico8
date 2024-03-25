Character = {
    x=0,
    y=0,
    frame=1,
    speed=6,
    anim_speed=8,
    anim_frames={1,2},
    flip_x=false,
    is_moving = false,
    is_placing = nil, -- ent id of what we're placing
    is_removing = nil, --ent id of what we're removing
}

function Character.draw(x,y)
    local f=Character.anim_frames[
        1+(flr(Character.frame) % #Character.anim_frames)
    ]
    spr(f,x,y,1,1,Character.flip_x)
end
