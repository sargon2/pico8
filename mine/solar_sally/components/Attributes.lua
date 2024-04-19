
Attr_WalkingObstruction = {}
Attr_pluggable = {}
Attr_removable = {}
Attr_is_circuit_component = {}
Attr_placement_sprite = {}
Attr_action_sprite = {}
Attr_action_fn = {}
Attr_action_release_fn = {}
Attr_DrawFn = {} -- fn(x, y, ent_id, relative_to_screen)

function Attributes_set_attr(ent_id, key, val) -- TODO finish inlining this everywhere
    key[ent_id] = val or true
end

function Attributes_get_attr_by_location(x, y, key)
    local ent = Locations.entity_at(x, y)
    if(not ent) return nil
    return key[ent]
end