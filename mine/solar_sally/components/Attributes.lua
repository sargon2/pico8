Attributes__attr = {}

--[[const]] Attr_WalkingObstruction = 1
--[[const]] Attr_pluggable = 2
--[[const]] Attr_removable = 3
--[[const]] Attr_is_circuit_component = 4
--[[const]] Attr_placement_sprite = 5

function Attributes_set_attr(ent_id, key, value)
    if(not Attributes__attr[ent_id]) Attributes__attr[ent_id] = {}
    Attributes__attr[ent_id][key] = value or true -- this looks strange but allows us to set boolean attributes easily
end

function Attributes_get_attr(ent_id, key)
    if(not Attributes__attr[ent_id]) return nil
    return Attributes__attr[ent_id][key]
end

function Attributes_get_attr_by_location(x, y, key)
    local ent = Locations.entity_at(x, y)
    if(not ent) return nil
    return Attributes_get_attr(ent, key)
end