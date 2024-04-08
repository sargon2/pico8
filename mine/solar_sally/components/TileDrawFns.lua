TileDrawFns = {
    fns = {}, -- fns[ent_id] = fn
}

function TileDrawFns.add(ent_id, fn)
    TileDrawFns.fns[ent_id] = fn
end

function TileDrawFns.drawTileAt(ent_id, x, y)
    if(not TileDrawFns.fns[ent_id]) return

    TileDrawFns.fns[ent_id](x, y, ent_id)
end
