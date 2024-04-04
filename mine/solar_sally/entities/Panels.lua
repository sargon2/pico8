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
    Drawable.add_aggregate_draw_fn(ZValues["Panels"], Panels.draw_panels)
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

function Panels.draw_panels(char_x, char_y)
    local overlays=table_with_default_table_inserted()
    for t in Locations.getVisibleLocationsOfEntity(Panels.ent_id, char_x, char_y) do
        local x = t[1]
        local y = t[2]
        -- draw overlays
        -- careful about leg length
        if Panels._panel_at(x+1, y+1) then
            -- short legs override long
            if not overlays[x][y] then
                if Panels._panel_at(x, y+1) then
                    overlays[x][y]=2
                else
                    overlays[x][y]=1
                end
            end
        end
        if Panels._panel_at(x+1, y-1) then
            overlays[x][y-1]=2
        end
        Sprites.draw_spr("solar_panel",x,y)
        if Panels.powered_panels:is_set(x, y) then
            Sprites.set_pixel(x,y,4,4,11)
        end
    end
    for x,row in pairs(overlays) do
        for y,v in pairs(row) do
            Sprites.draw_spr("solar_panel_overlay_ul",x,y)
            Sprites.draw_spr("solar_panel_overlay_lr",x+1,y+1)
            Sprites.draw_spr("solar_panel_overlay_ur",x+1,y)
            if v==1 then
                Sprites.draw_spr("solar_panel_overlay_ll",x,y+1)
            else
                Sprites.draw_spr("solar_panel_overlay_ll_short_leg",x,y+1)
            end
        end
    end
end
