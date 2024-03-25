-- TODO rename LocationsComponent since it handles multiple
LocationComponent = {
    entity_id = nil
}

LocationComponent = ECSComponent:new() -- make LocationComponent inherit from ECSComponent
LocationComponent.component_type = "LocationComponent"
LocationComponent.__index = LocationComponent

-- TODO this is global
entities_by_location = table_with_default_val_inserted({}) -- TODO multiple entities at one location?

function LocationComponent:new(entity_id)
    local o = {}
    setmetatable(o, self)

    o.entity_id = entity_id
    return o
end

function LocationComponent:getEntityAt(x, y)
    return entities_by_location[x][y]
end

function LocationComponent:associate_location(x, y)
    entities_by_location[x][y] = self.entity_id
end

function LocationComponent:get_all_locations() -- that match our entity_id
    local ret = table_with_default_val_inserted({})
    for x, ys in pairs(entities_by_location) do
        for y, ent_id in pairs(ys) do
            if ent_id == self.entity_id then
                add(ret[x], y)
            end
        end
    end
    return ret
end

-- TODO getEntitiesWithin(), getAllVisibleComponents(), getAllVisibleComponentsOfType(component_type)
function LocationComponent:getLocationsWithin(xmin, xmax, ymin, ymax) -- that match our entity_id
    local ret = table_with_default_val_inserted({})
    for x, ys in pairs(entities_by_location) do
        if xmin <= x and x <= xmax then
            for y, ent_id in pairs(ys) do
                if ymin <= y and y <= ymax do
                    if ent_id == self.entity_id then
                        add(ret[x], y)
                    end
                end
            end
        end
    end
    return ret
end

-- TODO static -- does it go on the metatable?
function LocationComponent:getEntitiesWithin(xmin, xmax, ymin, ymax)
    local ret = {}
    for x, ys in pairs(entities_by_location) do
        if xmin <= x and x <= xmax then
            for y, ent_id in pairs(ys) do
                if ymin <= y and y <= ymax do
                    add(ret, ent_id)
                end
            end
        end
    end
    return ret
end

function LocationComponent:getVisibleLocations(x, y) -- that match our entity_id
    return self:getLocationsWithin(x - 9, x + 8, y - 9, y + 8)
end

function LocationComponent:getVisibleEntities(x, y)
    return self:getEntitiesWithin(x - 9, x + 8, y - 9, y + 8)
end
