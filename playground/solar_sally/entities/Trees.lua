Trees = {}

function Trees.on_load()
    Attr_WalkingObstruction[Entities_Trees] = true
    Attr_WalkingObstruction[Entities_YoungTrees] = true
    Attr_chop_time[Entities_Trees] = Settings_axeswings_fullsizetree
    Attr_chop_time[Entities_YoungTrees] = Settings_axeswings_youngtree

    Sprites_add(Entities_Trees, Sprite_id_tree_top, 1, 2, -1)
    Sprites_add(Entities_YoungTrees, Sprite_id_young_tree, 1, 1)

    for _=1,500 do
        local x = flr(rnd(100))-50
        local y = flr(rnd(100))-50
        if abs(x) > 3 or abs(y) > 3 then -- Don't want a tree starting right over Sally
            if rnd(100) < 50 then
                Locations_place_entity(Entities_Trees, x, y)
            else
                Locations_place_entity(Entities_YoungTrees, x, y)
            end
        end
    end

    -- De-homogenize by advancing a bit
    for _=1,5000 do
        Trees.update()
    end
end

function Trees.update()
    local rnd_x = flr(rnd(100))-50 -- note same as placement formula
    local rnd_y = flr(rnd(100))-50
    local ent_id = Locations_entity_at(rnd_x, rnd_y)

    if ent_id == Entities_YoungTrees then
        -- Sometimes young trees grow up
        Locations_place_entity(Entities_Trees, rnd_x, rnd_y)
    elseif ent_id == Entities_Trees then
        -- The split between reproducing and dying has to be carefully tuned to avoid overpopulation/extinction.
        -- Sometimes old trees reproduce
        if rnd(100) < 54 then
            local nearby_x = rnd_x + flr(rnd(6))-3
            local nearby_y = rnd_y + flr(rnd(6))-3
            if not Locations_entity_at(nearby_x, nearby_y) then
                if not SmoothLocations_is_obstructed(nearby_x, nearby_y) then
                    Locations_place_entity(Entities_YoungTrees, nearby_x, nearby_y)
                end
            end
        end

        -- Sometimes old trees die
        if rnd(100) < 46 then
            Locations_place_entity(nil, rnd_x, rnd_y)
        end
    end
end

function Trees_advanceTimeDays(d)
    for _=1,d do
        -- tree updating is weird -- to get the player to see trees changing, we update quite
        -- fast when the player is in real-time, but when we're timeskipping we don't update
        -- as much as we should in relation.
        for _2=1,100 do
            Trees.update()
        end
    end
end

function Trees_advanceTimeYears(y)
    for _=1,y do
        for _2=1,100 do
            Trees_advanceTimeDays(1)
        end
    end
end