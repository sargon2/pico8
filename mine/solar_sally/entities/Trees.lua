Trees = {
    ent_id = nil,
}

function Trees.init()
    Trees.ent_id = Entities.create_entity()

    Attributes.set_attr(Trees.ent_id, "WalkingObstruction", true)

    Drawable.add_tile_draw_fn(ZValues["TreeBottoms"], Trees.ent_id, Trees.draw_tree)
    Drawable.add_tile_draw_fn(ZValues["TreeTops"], Trees.ent_id, Trees.draw_tree_top)

    for i=1,500 do
        local x = flr(rnd(100))-50
        local y = flr(rnd(100))-50
        Locations.place_entity(Trees.ent_id, x, y)
    end
end

function Trees.draw_tree(x, y)
    Sprites.draw_spr("tree_bottom", x, y)
end

function Trees.draw_tree_top(x, y)
    Sprites.draw_spr("tree_top", x, y-1)
end