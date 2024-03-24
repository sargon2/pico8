ECS = {
    current_entity_id = 0,
    components = table_with_default_val_inserted({}), -- [component_type][entity_id]
}

function ECS:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ECS:associate_component(entity_id, component_type, data)
    assert(component_type ~= nil)
    -- TODO should this prevent adding the same component to the same entity twice?
    local component = component_type:new(entity_id, data)
    self.components[component_type.component_type][entity_id] = component
    return component
end

function ECS:get_component(entity_id, component_type)
    return self.components[component_type.component_type][entity_id]
end

function ECS:create_entity()
    -- returns an integer id
    self.current_entity_id += 1
    return self.current_entity_id
end

function ECS:get_all_components_with_type(component_type)
    return self.components[component_type.component_type]
end

ECSComponent = {
    component_type = nil,
    entity = nil,
    data = nil,
}

ECSComponent.__index = ECSComponent
function ECSComponent:new()
    local o = {}
    setmetatable(o, self)
    return o
end

-- Global singleton instance of the ECS
ecs = ECS:new()