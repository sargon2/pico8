TileDrawFns = {
    fns = {}, -- fns[ent_id] = fn
}

function TileDrawFns.add(ent_id, fn)
    TileDrawFns.fns[ent_id] = fn
end

function TileDrawFns.draw(x, y)
    local ent_id = Locations.entity_at(x, y)

    if(not ent_id) return
    if(not TileDrawFns.fns[ent_id]) return

    TileDrawFns.fns[ent_id](x, y)
end
