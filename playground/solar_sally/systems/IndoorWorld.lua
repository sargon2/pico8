IndoorWorld = {}

--[[const]] local IndoorWorld_house_x_offset = 18
--[[const]] local IndoorWorld_house_y_offset = -3

local is_exiting -- prevent reentrance on the exit coroutine
local bed_selected = false

-- Hardcode the location of the bed rather than searching for it for simplicity.
-- Can't be constant because they use sprite offsets.
local bed_x = 8 + Sprites_offsets[Sprite_id_bed_ul][1]/8
local bed_y = 6 + Sprites_offsets[Sprite_id_bed_ul][2]/8

function IndoorWorld.on_enable()
    is_exiting = false
end

function IndoorWorld_draw_floor_behinds()
    for x=1,16 do
        for y=1,16 do
            if fget(mget(x+IndoorWorld_house_x_offset, y+IndoorWorld_house_y_offset), Sprite_flag_indoor_has_floor_behind) then
                local flr = Sprite_id_floor_2
                if(x%2==0) flr = Sprite_id_floor_1
                spr(flr, x*8, y*8)
            end
        end
    end
end

function IndoorWorld_mymap(celx, cely, sx, sy, celw, celh, layer)
    -- Replacement for map() that supports my sprite flags.  It's a lot slower than map().
    if(sx == nil) sx = 0
    if(sy == nil) sy = 0
    if(celw == nil) celw = 15
    if(celh == nil) celh = 15
    if(layer == nil) layer = 0
    sx/=8
    sy/=8
    for x=0,celw do
        for y=0,celh do
            local sprid = mget(x+celx, y+cely)
            if(sprid != 0 and (layer == 0 or (fget(sprid) & layer != 0))) Sprites_draw_spr(sprid, x+sx, y+sy, 1, 1, false, true)
        end
    end
end

function IndoorWorld.draw()
    -- Get the character's position
    local char_x, char_y = SmoothLocations_get_location(Entities_Character)

    -- Check if we're exiting
    if not is_exiting and IndoorWorld__get_flag(char_x, char_y, Sprite_flag_exits) then
        is_exiting = true
        CoroutineRunner_StartScriptWithFade(function ()
            Modes_switch_mode(Mode_Overworld)
            SmoothLocations_set_or_update_location(Entities_Character, 0, 0)
        end)
        return
    end

    -- Draw floors behind transparent sprites that want floor behind them
    IndoorWorld_draw_floor_behinds()

    -- Draw the layer that's always behind the character
    IndoorWorld_mymap(IndoorWorld_house_x_offset, IndoorWorld_house_y_offset)

    -- Draw the character
    Character_drawChar(char_x, char_y, Entities_Character, true)

    -- Draw the layer that's sometimes in front of the character
    local draw_boundary = flr(char_y) + 1
    IndoorWorld_mymap(IndoorWorld_house_x_offset, IndoorWorld_house_y_offset+draw_boundary, 0, draw_boundary*8, nil, 16-draw_boundary, 1 << Sprite_flag_layer_bit1)

    -- Draw the layer that's always in front of the character
    IndoorWorld_mymap(IndoorWorld_house_x_offset, IndoorWorld_house_y_offset, 0, 0, nil, nil, 1 << Sprite_flag_layer_bit2)

    -- Draw the selection box around the bed if Sally's close to it
    IndoorWorld__draw_bed_sel()
end

function IndoorWorld__draw_bed_sel()
    if bed_selected then
        Actions_draw_selection_box(bed_x, bed_y, 2, 2, true)
        Sprites_draw_spr(Sprite_id_sleep_icon, bed_x+.375, bed_y-1, 1, 1, false, true)
    end
end

function IndoorWorld.update()
    -- Is Sally close to the bed? If so, select it.
    local char_x, char_y = SmoothLocations_get_location(Entities_Character)

    -- Not sure why the zeroes here, but it seems to work.
    --[[const]] local boundary_left = 1
    --[[const]] local boundary_right = 0
    --[[const]] local boundary_top = 1
    --[[const]] local boundary_bottom = 0

    bed_selected = (
        (bed_x-boundary_left) < char_x and
        char_x < (bed_x+2+boundary_right) and
        (bed_y-boundary_top) < char_y and
        char_y < (bed_y+2+boundary_bottom)
    )

    if my_btn(Button_take_action) then
        if bed_selected then
            CoroutineRunner_StartScriptWithFade(function ()
                advance_time_days(1)
                yield_for_seconds(1.5)
                Modes_switch_mode(Mode_SleepResults)
            end)
        end
    end
end

function IndoorWorld__get_flag(x, y, flag)
    return fget(IndoorWorld__get_sprite(x, y), flag)
end

function IndoorWorld__get_sprite(x, y)
    return mget(flr(x+IndoorWorld_house_x_offset+.5), flr(y+IndoorWorld_house_y_offset+.5))
end

function IndoorWorld.is_obstructed(x, y)
    -- Get first sprite to check offsets
    local sprite = IndoorWorld__get_sprite(x, y)
    local offsets = Sprites_offsets[sprite]
    if(offsets != nil) then
        x -= offsets[1]/8
        y -= offsets[2]/8
        sprite = IndoorWorld__get_sprite(x, y) -- the sprite may have changed from the offset
    end

    -- These < and >= are reversed because when we get the flag, we add .5 to x.
    if(fget(sprite, Sprite_flag_indoor_walking_obstruction_left) and (x-flr(x) >= .5)) return true

    if(fget(sprite, Sprite_flag_indoor_walking_obstruction_right) and (x-flr(x) <= .5)) return true

    return false
end
