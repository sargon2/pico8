LocationComponent = {
    x = 0,
    y = 0
}

LocationComponent = ECSComponent:new() -- make LocationComponent inherit from ECSComponent
LocationComponent.component_type = "LocationComponent"
LocationComponent.__index = LocationComponent

components_by_location = {}

function LocationComponent:new(entity_id, data)
    local o = {}
    setmetatable(o, self)

    o.entity_id = entity_id
    if data then
        o.x = data.x
        o.y = data.y
    else
        o.x = 0
        o.y = 0
    end

    components_by_location[o.x][o.y]
    return o
end

function LocationComponent:getPosition()
    return self.x, self.y
end

function LocationComponent:getComponentAt(x, y)
    -- TODO this should be O(1), not O(n) -- build components_by_location in new() and reference it here
end