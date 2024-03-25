Wire = {
    ent_id = nil,
}

function Wire.init()
    Wire.ent_id = Entities.create_entity()
    ObjectTypes.add_entity(Wire.ent_id, "wire")
end

function Wire.place_wire_at(x, y) -- TODO dup'd with panels
    Locations.place_entity(Wire.ent_id, x, y)
end

function Wire.wire_at(x, y) -- TODO dup'd with panels
    if Locations.entity_at(x, y) == Wire.ent_id then
        return true
    end
    return false
end

function Wire.draw_wire_tile(x, y)
    local left = Wire.wire_at(x-1,y)
    local right = Wire.wire_at(x+1,y)
    local up = Wire.wire_at(x,y-1)
    local down = Wire.wire_at(x,y+1)

    -- straight has a couple of special cases (0 or 1 connections)
    if not up and not down then
        Sprites.draw_spr("wire_left", x, y)
        Sprites.draw_spr("wire_right", x, y)
        return
    end
    if not left and not right then
        Sprites.draw_spr("wire_up", x, y)
        Sprites.draw_spr("wire_down", x, y)
        return
    end

    -- the other cases are all straightforward.  The order here matters for wire overlap.
    if up then
        Sprites.draw_spr("wire_up", x, y)
    end
    if left then
        Sprites.draw_spr("wire_left", x, y)
    end
    if right then
        Sprites.draw_spr("wire_right", x, y)
    end
    if down then
        Sprites.draw_spr("wire_down", x, y)
    end
end

function Wire.draw_wire(x, y) -- TODO dup'd with draw_rocks
    local locations = Locations.getVisibleLocationsOfEntity(Wire.ent_id, x, y)

    for x,ys in pairs(locations) do
        for y in all(ys) do
            Wire.draw_wire_tile(x,y)
        end
    end
end
