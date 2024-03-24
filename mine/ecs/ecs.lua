ECS = {
    current_entity_id = 0,
    -- components = table_with_default_val_inserted(table_with_default_val_inserted({})), -- components[component_type][entity_id] = {components... }
    components = {},
}

function ECS:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ECS:associate_component(entity_id, component_type, data)
    -- TODO should components track their entity ids instead of tracking them in ECS?
    assert(component_type ~= nil)
    -- TODO should this prevent adding the same component to the same entity twice?
    local component = component_type:new(entity_id, data)
    if self.components[component_type.component_type] == nil then -- TODO
        self.components[component_type.component_type] = {}
    end
    if self.components[component_type.component_type][entity_id] == nil then -- TODO
        self.components[component_type.component_type][entity_id] = {}
    end
    add(self.components[component_type.component_type][entity_id], component)
    return component
end

function ECS:get_components(entity_id, component_type)
    if entity_id == nil then
        return nil
    end
    return self.components[component_type.component_type][entity_id]
end

function ECS:has_components(entity_id, component_type)
    -- Return boolean whether or not it has it
    local c = self:get_components(entity_id, component_type)
    if c == nil or #c == 0 then
        return false
    end
    return true
end

function ECS:create_entity()
    -- returns an integer id
    self.current_entity_id += 1
    return self.current_entity_id
end

-- TODO this shouldn't live here
function addAll(target, to_insert)
    for x in all(to_insert) do
        add(target, x)
    end
end

function ECS:get_all_components_with_type(component_type)
    local ret = {}
    for entity_id, components in pairs(self.components[component_type.component_type]) do
        addAll(ret, components)
    end
    return ret
end

ECSComponent = {
    component_type = nil,
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