Panels = {
    powered_panels = nil,
}

function Panels.init()
    Panels.clear_powered()

    Attributes_set_attr(Entities_Panels, Attr_WalkingObstruction)
    Attributes_set_attr(Entities_Panels, Attr_removable)
    Attributes_set_attr(Entities_Panels, Attr_is_circuit_component)
    Attributes_set_attr(Entities_Panels, Attr_pluggable)
    Attributes_set_attr(Entities_Panels, Attr_placement_sprite, Sprite_id_place_panel)
    Attributes_set_attr(Entities_Panels, Attr_DrawFn, Panels._draw)
end

function Panels._panel_at(x, y)
    return Locations_entity_at(x, y) == Entities_Panels
end

-- TODO these powered functions are duplicated with Transformers
function Panels.clear_powered()
    Panels.powered_panels = NewObj(BooleanGrid)
end

function Panels.mark_powered(x, y)
    Panels.powered_panels:set(x, y)
end

function Panels.is_powered(x, y)
    return Panels.powered_panels:is_set(x, y)
end

function Panels._draw(x, y, ent_id, relative_to_screen)
    Sprites_draw_spr(Sprite_id_solar_panel, x, y, 1, 1, false, relative_to_screen)
    if relative_to_screen or Panels.powered_panels:is_set(x, y) then
        Sprites_set_pixel(x,y,4,4,11, relative_to_screen)
    end
end