DrawFns = {
    fns = {}, -- fns[ent_id] = fn
}

function DrawFns.add(ent_id, fn)
    DrawFns.fns[ent_id] = fn
end

function DrawFns.drawTileAt(ent_id, x, y)
    if(not DrawFns.fns[ent_id]) return

    DrawFns.fns[ent_id](x, y, ent_id)
end
