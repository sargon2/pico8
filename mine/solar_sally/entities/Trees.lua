Trees = {}

function Trees.init()
    Attr_WalkingObstruction[Entities_Trees] = true

    Sprites_add(Entities_Trees, Sprite_id_tree_top, 1, 2, -1)

    for _=1,500 do
        local x = flr(rnd(100))-50
        local y = flr(rnd(100))-50
        if x != 0 or y != 1 then -- Don't want a tree starting right over Sally
            Locations_place_entity(Entities_Trees, x, y)
        end
    end
end
