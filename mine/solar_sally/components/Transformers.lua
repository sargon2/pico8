Transformers = {
    ent_left = nil,
    ent_right = nil,
}

function Transformers.init()
    Transformers.ent_left = Entities.create_entity()
    Transformers.ent_right = Entities.create_entity()

    Attributes.set_attr(Transformers.ent_left, "WalkingObstruction", true)
    Attributes.set_attr(Transformers.ent_right, "WalkingObstruction", true)

    Drawable.add_tile_sprite(Transformers.ent_left, "transformer_left")
    Drawable.add_tile_sprite(Transformers.ent_right, "transformer_right")

    Locations.place_entity(Transformers.ent_left, 2, 2)
    Locations.place_entity(Transformers.ent_right, 3, 2)
end
