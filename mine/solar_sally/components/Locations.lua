Locations = {
    locations = {}, -- locations[y][x] = ent_id -- y is first because we render the world in rows
}

function Locations.place_entity(ent_id, x, y)
    -- pass nil for ent_id to remove entity at location
    if not ent_id then
        if(not Locations.locations[y]) return
        Locations.locations[y][x] = nil
    else
        if(not Locations.locations[y]) Locations.locations[y] = {}
        Locations.locations[y][x] = ent_id
    end
end

function Locations.get_row(y)
    return Locations.locations[y]
end

function Locations.remove_entity(x, y)
    Locations.place_entity(nil, x, y)
end

function Locations.entity_at(x, y, debugging)
    if(not Locations.locations[y]) return nil
    return Locations.locations[y][x]
end

function Locations.iterate_all_entity_locations(ent_ids)
    return make_iter(Locations._iterate_all_entity_locations_co, ent_ids)
end

function Locations._iterate_all_entity_locations_co(ent_ids)
    for y, xs in pairs(Locations.locations) do
        for x, ent_id in pairs(xs) do
            if ent_ids == nil or contains(ent_ids, ent_id) then
                yield({x, y})
            end
        end
    end
end
