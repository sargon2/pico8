IndoorWorld = {
    name = "IndoorWorld"
}

function IndoorWorld.init()
    SmoothLocations_set_or_update_location(Entities_Character, 8, 8)
end

function IndoorWorld_draw_floor_behinds()
    for x=1,16 do
        for y=1,16 do
            if fget(mget(x+16, y-4), Sprite_flag_indoor_has_floor_behind) then
                local flr = Sprite_id_floor_2
                if(x%2==0) flr = Sprite_id_floor_1
                spr(flr, x*8, y*8)
            end
        end
    end
end

function IndoorWorld.draw()
    IndoorWorld_draw_floor_behinds()
    map(18,-2,16,16)
    local char_x, char_y = SmoothLocations_get_location(Entities_Character)

    Character_drawChar(char_x, char_y, Entities_Character, true)
end

function IndoorWorld.is_obstructed(x, y)
    --[[const]] local house_x_offset = 16.5
    --[[const]] local house_y_offset = -3.5
    local celx, cely = flr(x+house_x_offset), flr(y+house_y_offset)
    return fget(mget(celx, cely), Sprite_flag_indoor_walking_obstruction)
end