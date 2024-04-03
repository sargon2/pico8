Attributes = {
    attr = table_with_default_table_inserted()
}

function Attributes.set_attr(ent_id, key, value)
    Attributes.attr[ent_id][key] = value
end

function Attributes.set_attrs(ent_id, ...)
    for k, v in pairs(...) do
        Attributes.set_attr(ent_id, k, v)
    end
end

function Attributes.get_attr(ent_id, key)
    return Attributes.attr[ent_id][key]
end

function Attributes.get_attr_by_location(x, y, key)
    local ent = Locations.entity_at(x, y)
    if ent == nil then
        return false
    end
    return Attributes.attr[ent][key]
end