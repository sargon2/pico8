Locations = {
    locations = {}, -- locations[x][y] = ent_id
}

function Locations.place_entity(ent_id, x, y)
    -- pass nil for ent_id to remove entity at location
    if not ent_id then
        if(not Locations.locations[x]) return
        Locations.locations[x][y] = nil
        if(not next(Locations.locations[x])) Locations.locations[x] = nil
    else
        if(not Locations.locations[x]) Locations.locations[x] = {}
        Locations.locations[x][y] = ent_id
    end
end

function Locations.remove_entity(x, y) -- TODO make sure we're only calling this once per removal; I saw it being called 3 times
    Locations.place_entity(nil, x, y)
end

function Locations.entity_at(x, y)
    if(not Locations.locations[x]) return nil
    return Locations.locations[x][y]
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
