ObjectTypes = { -- e.g. "rock", "panel", "wire", etc.
    types = {}
}

function ObjectTypes.add_entity(ent_id, type)
    ObjectTypes.types[ent_id] = type
end

function ObjectTypes.type_of(ent_id)
    return ObjectTypes.types[ent_id]
end
