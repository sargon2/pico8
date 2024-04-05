Locations = {
    locations = table_with_default_table_inserted(), -- locations[x][y] = ent_id
}

function Locations.place_entity(ent_id, x, y)
    -- pass nil for ent_id to remove entity at location
    Locations.locations[x][y] = ent_id
end

function Locations.remove_entity(x, y)
    Locations.place_entity(nil, x, y)
end

function Locations.entity_at(x, y)
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
