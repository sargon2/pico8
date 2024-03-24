DrawableComponent = {
    draw_fn = nil
}

DrawableComponent = ECSComponent:new()
DrawableComponent.component_type = "DrawableComponent"
DrawableComponent.__index = DrawableComponent

function DrawableComponent:new(entity_id, draw_fn)
    local o = {}
    setmetatable(o, self)

    o.entity_id = entity_id
    o.draw_fn = draw_fn

    return o
end

function DrawableComponent:draw()
    self.draw_fn()
end