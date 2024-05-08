Panels = {}

Panels_powered_panels = nil

function Panels.init()
    Panels_clear_powered()

    Attr_WalkingObstruction[Entities_Panels] = true
    Attr_removable[Entities_Panels] = true
    Attr_is_circuit_component[Entities_Panels] = true
    Attr_pluggable[Entities_Panels] = true
    Attr_mini_sprite[Entities_Panels] = Sprite_id_place_panel
    Attr_DrawFn[Entities_Panels] = Panels__draw
end

-- TODO these powered functions are duplicated with Transformers
function Panels_clear_powered()
    Panels_powered_panels = NewObj(BooleanGrid)
end

function Panels_mark_powered(x, y)
    Panels_powered_panels:set(x, y)
end

function Panels_is_powered(x, y)
    return Panels_powered_panels:is_set(x, y)
end

function Panels__draw(x, y, ent_id, relative_to_screen)
    Sprites_draw_spr(Sprite_id_solar_panel, x, y, 1, 1, false, relative_to_screen)
    if relative_to_screen or Panels_powered_panels:is_set(x, y) then
        Sprites_set_pixel(x,y,4,4,11, relative_to_screen)
    end
end