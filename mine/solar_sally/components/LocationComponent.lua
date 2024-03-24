LocationComponent = {
    x = 0,
    y = 0
}

LocationComponent = ECSComponent:new() -- make LocationComponent inherit from ECSComponent
LocationComponent.component_type = "LocationComponent"
LocationComponent.__index = LocationComponent

entities_by_location = table_with_default_val_inserted({})

function LocationComponent:new(entity_id, data)
    local o = {}
    setmetatable(o, self)

    o.entity_id = entity_id
    o.x = data.x
    o.y = data.y

    entities_by_location[o.x][o.y] = entity_id -- TODO multiple entities at one location?
    return o
end

function LocationComponent:getEntityAt(x, y)
    return entities_by_location[x][y]
end

function LocationComponent:getComponentsWithin(xmin, xmax, ymin, ymax)
    -- TODO this needs to be fast
    -- TODO getAllVisibleComponents(), getAllVisibleComponentsOfType(component_type)
end