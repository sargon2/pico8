-- TODO this could just be an attribute
DrawFns = {
    fns = {}, -- fns[ent_id] = fn
}

function DrawFns.add(ent_id, fn)
    DrawFns.fns[ent_id] = fn
end

function DrawFns.drawTileAt(ent_id, x, y, relative_to_screen)
    DrawFns.fns[ent_id](x, y, ent_id, relative_to_screen) -- TODO the args here are in a different order than the outer function
end
