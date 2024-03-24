RockComponent = {
    locationComponent = nil
}

RockComponent = ECSComponent:new()
RockComponent.component_type = "RockComponent"
RockComponent.__index = RockComponent

function RockComponent:new(entity_id, data)
    local o = {}
    setmetatable(o, self)

    o.entity_id = entity_id

    -- Rock contains a nested Location
    o.locationComponent = ecs:associate_component(entity_id, LocationComponent, data)

    return o
end
