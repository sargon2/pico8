Axe = {}

local Axe_continue_cutting -- bool -- TODO should this really live here? Or should there be some other cancel operation or something?

function Axe.init()
    -- TODO this doesn't allow for more than one action on trees, maybe it should be like:
    -- add_action(Entities_trees, Axe_begin_action, Axe_end_action, Sprite_id_place_axe, Settings_axe_min_dist)
    Attr_mini_sprite[Entities_Trees] = Sprite_id_place_axe
    Attr_mini_sprite[Entities_YoungTrees] = Sprite_id_place_axe

    Attr_action_mindist[Entities_Trees] = Settings_axe_min_dist
    Attr_action_mindist[Entities_YoungTrees] = Settings_axe_min_dist

    Attr_action_fn[Entities_Trees] = Axe_begin_action
    Attr_action_fn[Entities_YoungTrees] = Axe_begin_action

    Attr_action_release_fn[Entities_Trees] = Axe_end_action
    Attr_action_release_fn[Entities_YoungTrees] = Axe_end_action
end

-- Not needed until there's a way to drop the axe
-- function Axe.destroy()
--     Attr_mini_sprite[Entities_Trees] = nil
--     Attr_mini_sprite[Entities_YoungTrees] = nil

--     Attr_action_mindist[Entities_Trees] = nil
--     Attr_action_mindist[Entities_YoungTrees] = nil

--     Attr_action_fn[Entities_Trees] = nil
--     Attr_action_fn[Entities_YoungTrees] = nil

--     Attr_action_release_fn[Entities_Trees] = nil
--     Attr_action_release_fn[Entities_YoungTrees] = nil
-- end

function Axe_end_action()
    Character.set_temp_frame(nil)
    Axe_continue_cutting = false
end

function Axe_begin_action(ent_id, x, y)
    Axe_continue_cutting = true
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
                if(Character.is_moving) Axe_end_action() -- Cancel the operation if the player moves
                if(not Axe_continue_cutting) return
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

