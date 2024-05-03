-- TODO name this

IndoorWorld = {
    name = "IndoorWorld"
}

function IndoorWorld.init()
    SmoothLocations_set_or_update_location(Entities_Character, 8, 8)
end

function IndoorWorld.draw()
    map(0,0,16,16)
    local char_x, char_y = SmoothLocations_get_location(Entities_Character)

    Character.drawChar(char_x, char_y, Entities_Character, true)
end