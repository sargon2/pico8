Panels = {
    ent_id = nil,
    powered_panels = nil,
}

function Panels.init()
    Panels.ent_id = Entities.create_entity()

    Panels.clear_powered()

    Attributes.set_attrs(Panels.ent_id,
        {
            WalkingObstruction = true,
            removable = true,
            is_circuit_component = true,
            placement_sprite = "place_panel",
            pluggable = true,
        }
    )
    DrawFns.add(Panels.ent_id, Panels._draw)
end

function Panels._panel_at(x, y)
    return Locations.entity_at(x, y) == Panels.ent_id
end

-- TODO these powered functions are duplicated with Transformers
function Panels.clear_powered()
    Panels.powered_panels = BooleanGrid:new()
end

function Panels.mark_powered(x, y)
    Panels.powered_panels:set(x, y)
end

function Panels.is_powered(x, y)
    return Panels.powered_panels:is_set(x, y)
end

function Panels._draw(x, y, is_powered, relative_to_screen)
    Sprites.draw_spr(Sprite_ids["solar_panel"], x, y, 1, 1, false, relative_to_screen)
    if relative_to_screen or Panels.powered_panels:is_set(x, y) then
        Sprites.set_pixel(x,y,4,4,11, relative_to_screen)
    end
end