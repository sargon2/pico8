Trees = {
    ent_id = nil,
}

function Trees.init()
    Trees.ent_id = Entities.create_entity()

    Attributes_set_attr(Trees.ent_id, Attr_WalkingObstruction, true)

    Sprites.add(Trees.ent_id, Sprite_id_tree_top, 1, 2, -1)

    for _=1,500 do
        local x = flr(rnd(100))-50
        local y = flr(rnd(100))-50
        if x != 0 or y != 1 then -- Don't want a tree starting right over Sally
            Locations.place_entity(Trees.ent_id, x, y)
        end
    end
end
