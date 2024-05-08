--[[const]] Entities_None = 0
--[[const]] Entities_Button = 1
--[[const]] Entities_Character = 2
--[[const]] Entities_GridWire = 3
--[[const]] Entities_Panels = 4
--[[const]] Entities_Rocks = 5
--[[const]] Entities_Transformers_left = 6
--[[const]] Entities_Transformers_right = 7
--[[const]] Entities_Trees = 8
--[[const]] Entities_YoungTrees = 9
--[[const]] Entities_Wire = 10
--[[const]] Entities_Money = 11
--[[const]] Entities_Fence = 12

Entities_current_entity_id = 99

function Entities_create_entity()
    -- returns an integer id
    Entities_current_entity_id += 1
    return Entities_current_entity_id
end
