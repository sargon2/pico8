Transformers = {
    ent_left = nil,
    ent_right = nil,
    powered_transformers = nil,
    overloaded_transformers = nil,
}

function Transformers.init()
    Transformers.ent_left = Entities.create_entity()
    Transformers.ent_right = Entities.create_entity()

    Transformers.clear_powered()

    Attributes_set_attr(Transformers.ent_left, Attr_WalkingObstruction)
    Attributes_set_attr(Transformers.ent_left, Attr_removable)
    Attributes_set_attr(Transformers.ent_left, Attr_is_circuit_component)
    Attributes_set_attr(Transformers.ent_left, Attr_pluggable)
    Attributes_set_attr(Transformers.ent_left, Attr_placement_sprite, Sprite_id_place_transformer)

    Attributes_set_attr(Transformers.ent_right, Attr_WalkingObstruction)
    Attributes_set_attr(Transformers.ent_right, Attr_removable)
    Attributes_set_attr(Transformers.ent_right, Attr_is_circuit_component)
    Attributes_set_attr(Transformers.ent_right, Attr_pluggable)

    Attributes_set_attr(Transformers.ent_left, Attr_DrawFn, Transformers.draw_transformer)
    Attributes_set_attr(Transformers.ent_right, Attr_DrawFn, function () end) -- right is drawn by the left fn

    Placement.set_placement_fn(Transformers.ent_left, Transformers.place)

    Placement.set_removal_fn(Transformers.ent_left, Transformers.remove_left)
    Placement.set_removal_fn(Transformers.ent_right, Transformers.remove_right)

    Placement.set_placement_obstruction_fn(Transformers.ent_left, Transformers.placement_obstructed)
end

function Transformers.clear_powered()
    Transformers.powered_transformers = NewObj(BooleanGrid)
    Transformers.overloaded_transformers = NewObj(BooleanGrid)
end

function Transformers.mark_powered(x, y)
    -- Pass in location of left side
    Transformers.powered_transformers:set(x, y)
    Transformers.powered_transformers:set(x+1, y)
end

function Transformers.mark_overloaded(x, y)
    -- Pass in location of left side
    Transformers.overloaded_transformers:set(x, y)
    Transformers.overloaded_transformers:set(x+1, y)
end

function Transformers.is_powered(x, y)
    return Transformers.powered_transformers:is_set(x, y)
end

function Transformers.is_overloaded(x, y)
    return Transformers.overloaded_transformers:is_set(x, y)
end

function Transformers.place(x, y)
    Locations.place_entity(Transformers.ent_left, x, y)
    Locations.place_entity(Transformers.ent_right, x+1, y)
end

function Transformers.remove_left(x, y)
    Locations.remove_entity(x, y)
    Locations.remove_entity(x+1, y)
end

function Transformers.remove_right(x, y)
    Locations.remove_entity(x-1, y)
    Locations.remove_entity(x, y)
    return Transformers.ent_left -- Let placement know what we're really removing
end

function Transformers.placement_obstructed(x, y)
    -- Transformers are 2 squares wide, so if there's something to the right, placement is obstructed
    if Locations.entity_at(x+1, y) then
        return true
    end
    return false
end

function Transformers.draw_transformer(x, y, ent_id, relative_to_screen)
    if relative_to_screen then
        -- The regular sprite is too wide to fit in inventory, so just use the placement one, but scoot it up and left a bit
        Sprites.draw_spr(Sprite_id_place_transformer, x-.125, y-.25, 1, 1, false, true)
        return
    end
    Sprites.draw_spr(Sprite_id_transformer_left, x, y, 2, 1, false)
    if Transformers.is_overloaded(x, y) then
        Sprites.set_pixel(x,y,5,5,8)
    elseif Transformers.is_powered(x, y) then
        Sprites.set_pixel(x,y,5,5,11)
        -- Sprites.rect(x,y,5,4,4,5,11)
    end
end