Attributes = {
    attr = {}
}

function Attributes.set_attr(ent_id, key, value)
    if(not Attributes.attr[ent_id]) Attributes.attr[ent_id] = {}
    Attributes.attr[ent_id][key] = value
end

function Attributes.set_attrs(ent_id, ...)
    for k, v in pairs(...) do
        Attributes.set_attr(ent_id, k, v)
    end
end

function Attributes.get_attr(ent_id, key)
    if(not Attributes.attr[ent_id]) return nil
    return Attributes.attr[ent_id][key]
end

function Attributes.get_attr_by_location(x, y, key)
    local ent = Locations.entity_at(x, y)
    if ent == nil then
        return nil
    end
    if(not Attributes.attr[ent]) return nil
    return Attributes.attr[ent][key]
end