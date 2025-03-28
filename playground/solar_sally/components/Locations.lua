Locations_locations = {} -- locations[y][x] = ent_id -- y is first because we render the world in rows

function Locations_place_entity(ent_id, x, y)
    -- pass nil for ent_id to remove entity at location
    if not ent_id then
        if(not Locations_locations[y]) return
        Locations_locations[y][x] = nil
    else
        set_with_ensure(Locations_locations, y, x, ent_id)
    end
end

function Locations_get_row(y)
    return Locations_locations[y]
end

function Locations_remove_entity(x, y)
    Locations_place_entity(nil, x, y)
end

function Locations_entity_at(x, y)
    if(not Locations_locations[y]) return nil
    return Locations_locations[y][x]
end

function Locations_iterate_all_entity_locations(ent_id)
    return make_iter(Locations__iterate_all_entity_locations_co, ent_id)
end

function Locations__iterate_all_entity_locations_co(requested_ent_id)
    for y, xs in pairs(Locations_locations) do
        for x, ent_id in pairs(xs) do
            if ent_id == requested_ent_id then
                yield({x, y})
            end
        end
    end
end
