RockComponent = {
    locationComponent = nil,
    drawableComponent = nil,
}

RockComponent = ECSComponent:new()
RockComponent.component_type = "RockComponent"
RockComponent.__index = RockComponent

function RockComponent:new(entity_id)
    local o = {}
    setmetatable(o, self)

    o.entity_id = entity_id

    -- Rock contains a nested Location
    o.locationComponent = ecs:associate_component(entity_id, LocationComponent)
    o.drawableComponent = ecs:associate_component(entity_id, DrawableComponent, function () o:draw_rocks() end)

    o:distribute_rocks()

    return o
end

function RockComponent:distribute_rocks()
    for i=1,1000 do
        local x = flr(rnd(100))
        local y = flr(rnd(100))
        self.locationComponent:associate_location(x, y)
    end
end

function RockComponent:draw_rocks()
    -- Get the rock's nested location component
    for x, ys in pairs(self.locationComponent:getVisibleLocations(char.x, char.y)) do
        for y in all(ys) do
            draw_spr(sprites["rock"], x, y)
        end
    end
end
