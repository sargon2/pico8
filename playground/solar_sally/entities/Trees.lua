Trees = {
    name = "Trees",
}

local Trees_continue_cutting -- TODO should this really live here? Or should there be some other cancel operation or something?

function Trees.init()
    Attr_WalkingObstruction[Entities_Trees] = true
    Attr_WalkingObstruction[Entities_YoungTrees] = true

    Sprites_add(Entities_Trees, Sprite_id_tree_top, 1, 2, -1)
    Sprites_add(Entities_YoungTrees, Sprite_id_young_tree, 1, 1)

    Attr_mini_sprite[Entities_Trees] = Sprite_id_place_axe
    Attr_mini_sprite[Entities_YoungTrees] = Sprite_id_place_axe

    Attr_action_mindist[Entities_Trees] = Settings_axe_min_dist
    Attr_action_mindist[Entities_YoungTrees] = Settings_axe_min_dist

    local function end_action()
        Character.set_temp_frame(nil)
        Trees_continue_cutting = false
    end

    local function begin_action(ent_id, x, y)
        Trees_continue_cutting = true
        -- Face the tree
        local char_x, _ = SmoothLocations_get_location(Entities_Character)
        if x < char_x then
            Character.flip_x = true
        else
            Character.flip_x = false
        end
        CoroutineRunner_StartScript(function ()
            local time = Settings_axeswings_fullsizetree
            if(ent_id == Entities_YoungTrees) time = Settings_axeswings_youngtree
            for _=1,time do
                -- TODO animation for facing up, down
                for frame in all({Sprite_id_axe_swing_right_1, Sprite_id_axe_swing_right_2}) do
                    if(Character.is_moving) end_action() -- Cancel the operation if the player moves
                    if(not Trees_continue_cutting) return
                    Character.set_temp_frame(frame)
                    for _=1,Settings_axeswing_speed do -- Show the animation frame for n real frames
                        yield()
                    end
                end
            end
            -- TODO play animation for tree falling over
            Character.set_temp_frame(nil)
            Locations_remove_entity(x, y)
        end)
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