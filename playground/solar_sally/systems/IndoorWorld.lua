IndoorWorld = {}

--[[const]] local IndoorWorld_house_x_offset = 18
--[[const]] local IndoorWorld_house_y_offset = -3

local is_exiting -- prevent reentrance on the exit coroutine
local char_x_save, char_y_save -- save the character's location before they went inside

function IndoorWorld.init()
    char_x_save, char_y_save = SmoothLocations_get_location(Entities_Character)
    SmoothLocations_set_or_update_location(Entities_Character, 7, 7)
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

function IndoorWorld.draw()
    -- Get the character's position
    local char_x, char_y = SmoothLocations_get_location(Entities_Character)

    -- Check if we're exiting
    if not is_exiting and IndoorWorld__get_flag(char_x, char_y, Sprite_flag_exits) then
        is_exiting = true
        CoroutineRunner_StartScript(function ()
            fadeAndDisableInputForCo(function ()
                unload_system(IndoorWorld)
                load_system(Placement, 4)
                load_system(World, 2)
                SmoothLocations_set_or_update_location(Entities_Character, char_x_save, char_y_save)
            end)
        end)
        return
    end

    -- Draw floors behind transparent sprites that want floor behind them
    IndoorWorld_draw_floor_behinds()

    -- Draw the layer that's always behind the character
    map(IndoorWorld_house_x_offset, IndoorWorld_house_y_offset)

    -- Draw the character
    Character_drawChar(char_x, char_y, Entities_Character, true)

    -- Draw the layer that's sometimes in front of the character
    local draw_boundary = flr(char_y) + 1
    map(IndoorWorld_house_x_offset, IndoorWorld_house_y_offset+draw_boundary, 0, draw_boundary*8, nil, 16-draw_boundary, 1 << Sprite_flag_layer_bit1)

    -- Draw the layer that's always in front of the character
    map(IndoorWorld_house_x_offset, IndoorWorld_house_y_offset, 0, 0, nil, nil, 1 << Sprite_flag_layer_bit2)
end

function IndoorWorld__get_flag(x, y, flag)
    local celx, cely = flr(x+IndoorWorld_house_x_offset+.5), flr(y+IndoorWorld_house_y_offset+.5)
    return fget(mget(celx, cely), flag)
end

function IndoorWorld.is_obstructed(x, y)
    return IndoorWorld__get_flag(x, y, Sprite_flag_indoor_walking_obstruction)
end
