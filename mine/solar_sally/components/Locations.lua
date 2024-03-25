Locations = {
    -- TODO this is being used largely to get all locations of a certain entity, not all locations of all entities
    -- so maybe it'd make more sense to organize locations as locations[ent_id][x] = {y1, y2, ...}?
    -- maybe even don't track entity id? and this is just a boolean grid, and each of Rocks/Panels/etc. can just have an instance of it
    locations = table_with_default_val_inserted({}),
}

function Locations.place_entity(ent_id, x, y)
    -- pass nil for ent_id to remove entity at location
    Locations.locations[x][y] = ent_id
end

function Locations.remove_entity_at(x, y)
    Locations.place_entity(nil, x, y)
end

function Locations.entity_at(x, y)
    return Locations.locations[x][y]
end

function Locations.getEntitiesWithin(xmin, xmax, ymin, ymax)
    return getLocationsOfEntityWithin(nil, xmin, xmax, ymin, ymax)
end

function Locations.getLocationsOfEntityWithin(requested_ent_id, xmin, xmax, ymin, ymax)
    local ret = table_with_default_val_inserted({})
    for x, ys in pairs(Locations.locations) do
        if xmin <= x and x <= xmax then
            for y, ent_id in pairs(ys) do
                if requested_ent_id == nil or requested_ent_id == ent_id then
                    if ymin <= y and y <= ymax do
                        add(ret[x], y)
                    end
                end
            end
        end
    end
    return ret
end

function Locations.getVisibleEntities(x, y)
    return Locations.getEntitiesWithin(x - 9, x + 8, y - 9, y + 8)
end

function Locations.getVisibleLocationsOfEntity(ent_id, x, y)
    return Locations.getLocationsOfEntityWithin(ent_id, x - 9, x + 8, y - 9, y + 8)
end
