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

LocationComponent = ECSComponent:new() -- make LocationComponent inherit from ECSComponent
LocationComponent.component_type = "LocationComponent"
LocationComponent.__index = LocationComponent
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

    return o
end

function LocationComponent:getPosition()
    return self.x, self.y
end

function ECS:associate_component(entity_id, component_type, data)
    -- TODO should this prevent adding the same component to the same entity twice?
    local component = component_type:new(entity_id, data)
    add(self.components, component)
    return component
end

function ECS:get_component(entity_id, component_type)
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
    ret = {}
    for c in all(self.components) do
        if c.component_type == component_type.component_type then
            add(ret, c.entity_id)
        end
    end
    -- TODO include compound components, which might mean deduplicating or storing redundant data
    return ret
end

my_ecs = ECS:new()

eid = my_ecs:create_entity()
my_ecs:associate_component(eid, LocationComponent)
c = my_ecs:get_component(eid, LocationComponent)
x, y = c:getPosition()
print(tostr(x)..", "..tostr(y))

-- prove component data is mutable
c.x = 47
c.y = 23
x, y = c:getPosition()
print(tostr(x)..", "..tostr(y))

for x in all(my_ecs:get_all_entities(LocationComponent)) do
    print(x)
end

eid2 = my_ecs:create_entity()
c = my_ecs:associate_component(eid2, LocationComponent)
c.x = 10
c.y = 11
c = my_ecs:get_component(eid2, LocationComponent)
x, y = c:getPosition()
print("eid2:"..tostr(x)..", "..tostr(y))

c = my_ecs:get_component(eid, LocationComponent)
x, y = c:getPosition()
print("eid1:"..tostr(x)..", "..tostr(y))

for x in all(my_ecs:get_all_entities(LocationComponent)) do
    print(x)
end
