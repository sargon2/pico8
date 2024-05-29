Fence = {}

function Fence.on_load()
    Attr_WalkingObstruction[Entities_Fence] = true
    Attr_removable[Entities_Fence] = true
    Attr_pluggable[Entities_Fence] = true
    Attr_fence_linkable[Entities_Fence] = true
    Attr_mini_sprite[Entities_Fence] = Sprite_id_fence_mini
    Attr_DrawFn[Entities_Fence] = Fence_draw_fence
    Attr_action_speed[Entities_Fence] = Settings_fence_placement_speed
    Attr_removal_speed[Entities_Fence] = Settings_fence_removal_speed
end

function Fence_draw_fence(x, y, ent_id, relative_to_screen)
    Sprites_draw_linking(x, y, relative_to_screen, Attr_fence_linkable, Sprite_id_fence_left, Sprite_id_fence_right, Sprite_id_fence_up, Sprite_id_fence_down)
end
