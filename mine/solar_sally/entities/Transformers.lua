Transformers = {
    ent_left = nil,
    ent_right = nil,
}

function Transformers.init()
    Transformers.ent_left = Entities.create_entity()
    Transformers.ent_right = Entities.create_entity()

    Attributes.set_attrs(Transformers.ent_left, 
        {
            WalkingObstruction = true,
            placement_sprite = "place_transformer",
            removable = true,
            connectable = true,
        }
    )

    Attributes.set_attrs(Transformers.ent_right, 
        {
            WalkingObstruction = true,
            removable = true,
            connectable = true,
        }
    )

    Drawable.add_tile_sprite(ZValues["Transformers"], Transformers.ent_left, "transformer_left")
    Drawable.add_tile_sprite(ZValues["Transformers"], Transformers.ent_right, "transformer_right")

    Placement.set_placement_fn(Transformers.ent_left, Transformers.place)

    Placement.set_removal_fn(Transformers.ent_left, Transformers.remove_left)
    Placement.set_removal_fn(Transformers.ent_right, Transformers.remove_right)

    Placement.set_placement_obstruction_fn(Transformers.ent_left, Transformers.placement_obstructed)

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