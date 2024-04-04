Trees = {
    ent_id = nil,
}

function Trees.init()
    Trees.ent_id = Entities.create_entity()

    Attributes.set_attr(Trees.ent_id, "WalkingObstruction", true)

    Drawable.add_tile_draw_fn(ZValues["Trees"], Trees.ent_id, Trees.draw_tree)

    for i=1,1000 do
        local x = flr(rnd(100))
        local y = flr(rnd(100))
        Locations.place_entity(Trees.ent_id, x, y)
    end
end

function Trees.draw_tree(x, y)
    Sprites.draw_spr("tree_bottom", x, y)
    Sprites.draw_spr("tree_top", x, y-1)
end