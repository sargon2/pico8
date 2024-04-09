Actions = {
    sprites = {}, -- sprites[ent_id] = sprite
    fns = {}, -- fns[ent_id] = fn
    release_fns = {}, -- release_fns[ent_id] = fn
}

function Actions.trigger(ent_id)
    Actions.fns[ent_id]()
end

function Actions.release(ent_id)
    Actions.release_fns[ent_id]()
end

function Actions.set_action(ent_id, sprite, fn, release_fn)
    Actions.sprites[ent_id] = sprite
    Actions.fns[ent_id] = fn
    Actions.release_fns[ent_id] = release_fn
end

function Actions.get_sprite(ent_id)
    return Actions.sprites[ent_id]
end