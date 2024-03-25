Entities = {
    current_entity_id = 0
}

function Entities.create_entity()
    -- returns an integer id
    Entities.current_entity_id += 1
    return Entities.current_entity_id
end


Locations = {
    locations = table_with_default_val_inserted({}),
}

function Locations.add_entity(ent_id, x, y)
    Locations.locations[x][y] = ent_id
end

function Locations.getEntityAt(x, y)
    return Locations.locations[x][y]
end

function Locations.getEntitiesWithin(xmin, xmax, ymin, ymax)
    local ret = table_with_default_val_inserted({})
    for x, ys in pairs(Locations.locations) do
        if xmin <= x and x <= xmax then
            for y, ent_id in pairs(ys) do
                if ymin <= y and y <= ymax do
                    ret[x][y] = ent_id
                end
            end
        end
    end
    return ret
end

function Locations.getVisibleEntities(x, y)
    return Locations.getEntitiesWithin(x - 9, x + 8, y - 9, y + 8)
end


WalkingObstructions = {
    obstr = {}
}

function WalkingObstructions.add_entity(ent_id)
    WalkingObstructions.obstr[ent_id] = true
end

function WalkingObstructions.obstructs(ent_id)
    return WalkingObstructions.obstr[ent_id]
end

function WalkingObstructions.obstructed(x, y)
    return WalkingObstructions.obstructs(Locations.getEntityAt(x, y))
end


ObjectTypes = { -- e.g. "rock", "panel", "wire", etc.
    types = {}
}

function ObjectTypes.add_entity(ent_id, type)
    ObjectTypes.types[ent_id] = type
end

function ObjectTypes.get_type_of(ent_id)
    return ObjectTypes.types[ent_id]
end


Drawable = {
    draw_fns = {}
}

function Drawable.add_entity(ent_id, draw_fn)
    Drawable.draw_fns[ent_id] = draw_fn
end

function Drawable.draw(ent_id, x, y)
    Drawable.draw_fns[ent_id](x, y)
end


Rocks = {  -- Not a component, just a namespace.  Or is it a "system"?
    ent_id = nil
}

function Rocks.draw_one_rock(x, y)
    draw_spr(sprites["rock"], x, y)
end

function Rocks.create_rocks()
    Rocks.ent_id = Entities.create_entity()
    WalkingObstructions.add_entity(Rocks.ent_id)
    ObjectTypes.add_entity(Rocks.ent_id, "rock")
    Drawable.add_entity(Rocks.ent_id, Rocks.draw_one_rock)
    for i=1,1000 do
        local x = flr(rnd(100))
        local y = flr(rnd(100))
        Locations.add_entity(Rocks.ent_id, x, y)
    end
end


-- TODO This is simple, but is it fast?
-- TODO Where should this method live? I guess it's a "system"?
function RenderAll(x, y)
    -- Note draw order doesn't matter here because we can only have one entity per grid location.  Character, etc. is rendered after this

    local entities = Locations.getVisibleEntities(x, y)

    for x, ys in pairs(entities) do
        for y, ent_id in pairs(ys) do
            Drawable.draw(ent_id, x, y)
        end
    end

end