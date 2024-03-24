ECS = {
    current_entity_id = 0,
    components = {},
}

function ECS:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ECS:associate_component(entity_id, component_type, data)
    -- TODO should this prevent adding the same component to the same entity twice?
    local component = component_type:new(entity_id, data)
    add(self.components, component)
    return component
end

function ECS:get_component(entity_id, component_type)
    -- TODO this needs to be O(1), not O(n)
    for c in all(self.components) do
        if c.component_type == component_type.component_type and c.entity_id == entity_id then
            return c
        end
    end
    return nil
end

function ECS:create_entity()
    -- returns an integer id
    self.current_entity_id += 1
    return self.current_entity_id
end

function ECS:get_all_entities(component_type)
    local ret = {}
    for c in all(self.components) do
        if c.component_type == component_type.component_type then
            add(ret, c.entity_id)
        end
    end
    -- TODO include compound components, which might mean deduplicating or storing redundant data
    return ret
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