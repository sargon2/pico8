Rocks = {}

function Rocks.on_load()
    Attr_WalkingObstruction[Entities_Rocks] = true
    Sprites_add(Entities_Rocks, Sprite_id_rock)

    for _=1,500 do
        local x = flr(rnd(100))-50
        local y = flr(rnd(100))-50
        if abs(x) > 3 or abs(y) > 3 then -- Don't want a rock starting right over Sally
            Locations_place_entity(Entities_Rocks, x, y)
        end
    end
end