Axe = {}

local Axe_Coroutine

function Axe.on_load()
    Attr_mini_sprite[Entities_Trees] = Sprite_id_mini_axe
    Attr_mini_sprite[Entities_YoungTrees] = Sprite_id_mini_axe

    Attr_action_fn[Entities_Trees] = Axe_begin_action
    Attr_action_fn[Entities_YoungTrees] = Axe_begin_action

    Attr_action_release_fn[Entities_Trees] = Axe_end_action
    Attr_action_release_fn[Entities_YoungTrees] = Axe_end_action

    Inventory_addIcon(Sprite_id_inventory_axe)
end

-- Not needed until there's a way to drop the axe
-- function Axe.on_unload()
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
    Character_set_temp_frame(nil)
    CoroutineRunner_Cancel(Axe_Coroutine)
end

function Axe_begin_action(_act, x, y)
    -- Face the tree
    local ent_id = Locations_entity_at(x, y)
    if(ent_id == nil) return false

    -- Is the entity choppable?
    local time = Attr_chop_time[ent_id]
    if(time == nil) return false

    local char_x, char_y = SmoothLocations_get_location(Entities_Character)
    if x < char_x then
        Character_flip_x = true
    else
        Character_flip_x = false
    end
    -- check if the target is in range
    if dist(char_x, char_y, x, y) > Settings_axe_min_dist then
        return false
    end

    Axe_Coroutine = CoroutineRunner_StartScript(function ()
        if(not Settings_60fps) time /= 2
        for _=1,time do
            for frame in all({Sprite_id_axe_swing_right_1, Sprite_id_axe_swing_right_2}) do
                if(Character_or_action_moving) then
                    Axe_end_action() -- Cancel the operation if the player moves
                    return
                end
                Character_set_temp_frame(frame)
                for _=1,Settings_axeswing_speed do -- Show the animation frame for n real frames
                    yield()
                end
            end
        end
        Character_set_temp_frame(nil)
        complete_removal(ent_id, x, y) -- TODO rename this method
        Inventory_addMoney(Settings_tree_felling_payment)
    end)
    return true
end

