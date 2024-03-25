Drawable = {
    draw_fns = {}
}

function Drawable.add_entity(ent_id, draw_fn)
    Drawable.draw_fns[ent_id] = draw_fn
end

function Drawable.draw(ent_id, x, y)
    Drawable.draw_fns[ent_id](x, y)
end
