Wire = {}

function Wire.on_load()
    Attr_removable[Entities_Wire] = true
    Attr_pluggable[Entities_Wire] = true
    Attr_mini_sprite[Entities_Wire] = Sprite_id_place_wire
    Attr_DrawFn[Entities_Wire] = Wire_draw_wire_tile
    Attr_action_speed[Entities_Wire] = Settings_wire_placement_speed
    Attr_removal_speed[Entities_Wire] = Settings_wire_removal_speed
    Attr_chop_time[Entities_Wire] = Settings_axeswings_wire
end

function Wire_draw_wire_tile(x, y, ent_id, relative_to_screen)
    Sprites_draw_linking(x, y, relative_to_screen, Attr_pluggable, Sprite_id_wire_left, Sprite_id_wire_right, Sprite_id_wire_up, Sprite_id_wire_down)
end
