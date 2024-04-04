Locations = {
    locations = table_with_default_table_inserted(),
    ent_counts = table_with_default_val(0),
}

function Locations.place_entity(ent_id, x, y)
    -- pass nil for ent_id to remove entity at location
    if ent_id then
        Locations.ent_counts[ent_id] += 1
    else
        Locations.ent_counts[Locations.entity_at(x, y)] -= 1
    end
    Locations.locations[x][y] = ent_id
end

function Locations.remove_entity(x, y)
    Locations.place_entity(nil, x, y)
end

function Locations.count_placed(ent_id)
    return Locations.ent_counts[ent_id]
end

function Locations.entity_at(x, y)
    return Locations.locations[x][y]
end

function Locations.getEntitiesWithin(xmin, xmax, ymin, ymax)
    return getLocationsOfEntityWithin(nil, xmin, xmax, ymin, ymax)
end

function Locations.getLocationsOfEntityWithin(requested_ent_id, xmin, xmax, ymin, ymax)
    return make_iter(Locations._getLocationsOfEntityWithin_co, requested_ent_id, xmin, xmax, ymin, ymax)
end

function Locations._getLocationsOfEntityWithin_co(requested_ent_id, xmin, xmax, ymin, ymax)
    -- TODO this method would be a lot faster if we organized locations by entity id, like locations[ent_id][x][y] = true.  Is that worth the tradeoff?
    for x, ys in pairs(Locations.locations) do
        if xmin <= x and x <= xmax then
            for y, ent_id in pairs(ys) do
                if requested_ent_id == nil or requested_ent_id == ent_id then
                    if ymin <= y and y <= ymax then
                        yield({x, y})
                    end
                end
            end
        end
    end
end

function Locations.iterate_all_entity_locations(ent_ids)
    return make_iter(Locations._iterate_all_entity_locations_co, ent_ids)
end

function Locations._iterate_all_entity_locations_co(ent_ids)
    for x, ys in pairs(Locations.locations) do
        for y, ent_id in pairs(ys) do
            if ent_ids == nil or contains(ent_ids, ent_id) then
                yield({x, y})
            end
        end
    end
end

function Locations.iterate_all()
    return make_iter(Locations._iterate_all_entity_locations_co)
end

function Locations.getVisibleEntities(x, y)
    return Locations.getEntitiesWithin(x - 10, x + 8, y - 9, y + 9)
end

function Locations.getVisibleLocationsOfEntity(ent_id, x, y)
    return Locations.getLocationsOfEntityWithin(ent_id, x - 10, x + 8, y - 9, y + 9)
end
