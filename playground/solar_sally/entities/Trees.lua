Trees = {
    name = "Trees",
}

function Trees.init()
    Attr_WalkingObstruction[Entities_Trees] = true
    Attr_WalkingObstruction[Entities_YoungTrees] = true

    Sprites_add(Entities_Trees, Sprite_id_tree_top, 1, 2, -1)
    Sprites_add(Entities_YoungTrees, Sprite_id_young_tree, 1, 1)

    Attr_action_sprite[Entities_Trees] = Sprite_id_place_axe
    Attr_action_sprite[Entities_YoungTrees] = Sprite_id_place_axe

    -- TODO only show the axing action if the character is close enough to the tree to prevent wifi axing
    -- TODO make it take less hits to fell a young tree
    local continue_cutting -- TODO should this really live here? Or should there be some other cancel operation or something?
    local function begin_action(ent_id, x, y)
        continue_cutting = true
        -- Face the tree
        local char_x, _ = SmoothLocations_get_location(Entities_Character)
        if x < char_x then
            Character.flip_x = true
        else
            Character.flip_x = false
        end
        CoroutineRunner_StartScript(function ()
            for i=1,10 do -- TODO make the time it takes a setting
                -- TODO animation for facing up, down
                for frame in all({Sprite_id_axe_swing_right_1, Sprite_id_axe_swing_right_2}) do
                    if(not continue_cutting) return
                    Character.set_temp_frame(frame)
                    for _=1,10 do -- Show the animation frame for n real frames
                        yield()
                    end
                end
            end
            -- TODO play animation for tree falling over
            Character.set_temp_frame(nil)
            Locations_remove_entity(x, y)
        end)
    end

    local function end_action()
        -- TODO cancel axing action if player moves such that the selected location changes
        Character.set_temp_frame(nil)
        continue_cutting = false
    end

    Attr_action_fn[Entities_Trees] = begin_action
    Attr_action_fn[Entities_YoungTrees] = begin_action

    Attr_action_release_fn[Entities_Trees] = end_action
    Attr_action_release_fn[Entities_YoungTrees] = end_action

    for _=1,500 do
        local x = flr(rnd(100))-50
        local y = flr(rnd(100))-50
        if x != 0 or y != 1 then -- Don't want a tree starting right over Sally
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
    -- TODO this function is quite slow for moving large time periods. I guess we need a table of all trees?
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
    for i=1,d do
        -- tree updating is weird -- to get the player to see trees changing, we update quite
        -- fast when the player is in real-time, but when we're timeskipping we don't update
        -- as much as we should in relation.
        for j=1,100 do
            Trees.update()
        end
    end
end

function Trees_advanceTimeYears(y)
    for i=1,y do
        for j=1,100 do
            Trees_advanceTimeDays(1)
        end
    end
end