-- TODO all this stuff could just be attributes
Actions__sprites = {} -- sprites[ent_id] = sprite
Actions__fns = {} -- fns[ent_id] = fn
Actions__release_fns = {} -- release_fns[ent_id] = fn

function Actions_trigger(ent_id)
    Actions__fns[ent_id]()
end

function Actions_release(ent_id)
    Actions__release_fns[ent_id]()
end

function Actions_set_action(ent_id, sprite, fn, release_fn)
    Actions__sprites[ent_id] = sprite
    Actions__fns[ent_id] = fn
    Actions__release_fns[ent_id] = release_fn
end

function Actions_get_sprite(ent_id)
    return Actions__sprites[ent_id]
end