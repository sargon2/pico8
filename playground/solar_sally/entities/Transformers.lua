Transformers = {}

local Transformers_overloaded_transformers = nil

function Transformers.init()
    Attr_WalkingObstruction[Entities_Transformers_left] = true
    Attr_removable[Entities_Transformers_left] = true
    Attr_is_circuit_component[Entities_Transformers_left] = true
    Attr_pluggable[Entities_Transformers_left] = true
    Attr_mini_sprite[Entities_Transformers_left] = Sprite_id_place_transformer
    Attr_placement_speed[Entities_Transformers_left] = Settings_transformer_placement_speed
    Attr_removal_speed[Entities_Transformers_left] = Settings_transformer_removal_speed
    Attr_removal_speed[Entities_Transformers_right] = Settings_transformer_removal_speed

    Attr_WalkingObstruction[Entities_Transformers_right] = true
    Attr_removable[Entities_Transformers_right] = true
    Attr_is_circuit_component[Entities_Transformers_right] = true
    Attr_pluggable[Entities_Transformers_right] = true

    Attr_DrawFn[Entities_Transformers_left] = Transformers_draw_transformer
    Attr_DrawFn[Entities_Transformers_right] = function () end -- right is drawn by the left fn

    Placement_set_placement_fn(Entities_Transformers_left, Transformers_place)

    Placement_set_removal_fn(Entities_Transformers_left, Transformers_remove_left)
    Placement_set_removal_fn(Entities_Transformers_right, Transformers_remove_right)

    Placement_set_placement_obstruction_fn(Entities_Transformers_left, Transformers_placement_obstructed)
end

function Transformers_clear_overloaded()
    Transformers_overloaded_transformers = NewObj(BooleanGrid)
end

function Transformers_mark_powered(x, y)
    -- Pass in location of left side
    Attr_powered_grid:set(x, y)
    Attr_powered_grid:set(x+1, y)
end

function Transformers_mark_overloaded(x, y)
    -- Pass in location of left side
    Transformers_overloaded_transformers:set(x, y)
    Transformers_overloaded_transformers:set(x+1, y)
end

function Transformers_is_overloaded(x, y)
    return Transformers_overloaded_transformers:is_set(x, y)
end

function Transformers_place(x, y)
    Locations_place_entity(Entities_Transformers_left, x, y)
    Locations_place_entity(Entities_Transformers_right, x+1, y)
end

function Transformers_remove_left(x, y)
    Locations_remove_entity(x, y)
    Locations_remove_entity(x+1, y)
end

function Transformers_remove_right(x, y)
    Locations_remove_entity(x-1, y)
    Locations_remove_entity(x, y)
    return Entities_Transformers_left -- Let placement know what we're really removing
end

function Transformers_placement_obstructed(x, y)
    -- Transformers are 2 squares wide, so if there's something to the right, placement is obstructed
    if Locations_entity_at(x+1, y) then
        return true
    end
    return false
end

function Transformers_draw_transformer(x, y, ent_id, relative_to_screen)
    if relative_to_screen then
        -- The regular sprite is too wide to fit in inventory, so just use the placement one, but scoot it up and left a bit
        Sprites_draw_spr(Sprite_id_place_transformer, x-.125, y-.25, 1, 1, false, true)
        return
    end
    Sprites_draw_spr(Sprite_id_transformer_left, x, y, 2, 1, false)
    if Transformers_is_overloaded(x, y) then
        Sprites_set_pixel(x,y,5,5,8)
    elseif Attr_powered_grid:is_set(x, y) then
        Sprites_set_pixel(x,y,5,5,11)
        -- Sprites_rect(x,y,5,4,4,5,11)
    end
end