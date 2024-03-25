Panels = {
    ent_id = nil
}

function Panels.init()
    Panels.ent_id = Entities.create_entity()
    WalkingObstructions.add_entity(Panels.ent_id)
    ObjectTypes.add_entity(Panels.ent_id, "panel")
end

function Panels.panel_at(x, y) -- TODO this shouldn't exist because it's doing too many lookups
    if ObjectTypes.type_of(Locations.getEntityAt(x, y)) == "panel" then
        return true
    end
    return false
end

function Panels.place_panel_at(x, y)
    Locations.place_entity(Panels.ent_id, x, y)
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
