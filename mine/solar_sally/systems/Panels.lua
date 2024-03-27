Panels = {
    ent_id = nil
}

function Panels.init()
    Panels.ent_id = Entities.create_entity()
    Attributes.set_attr(Panels.ent_id, "WalkingObstruction", true)
    Drawable.add_aggregate_draw_fn(ZValues["Panels"], Panels.draw_panels)
    Attributes.set_attr(Panels.ent_id, "placement_sprite", "place_panel")
end

function Panels.panel_at(x, y)
    return Locations.entity_at(x, y) == Panels.ent_id
end

function Panels.draw_panels(x, y)
    panel_locations = Locations.getVisibleLocationsOfEntity(Panels.ent_id, x, y)
    local overlays=table_with_default_val_inserted({})
    for x,ys in pairs(panel_locations) do
        for y in all(ys) do
            -- draw overlays
            -- careful about leg length
            if Panels.panel_at(x+1, y+1) then
                -- short legs override long
                if not overlays[x][y] then
                    if Panels.panel_at(x, y+1) then
                        overlays[x][y]=2
                    else
                        overlays[x][y]=1
                    end
                end
            end
            if Panels.panel_at(x+1, y-1) then
                overlays[x][y-1]=2
            end
            Sprites.draw_spr("solar_panel",x,y)
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
