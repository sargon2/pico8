
-- TODO I could do like --[[const]] Entity_panel = 3 in this file, then panel doesn't have to call create_entity, to save on tokens

Entities = {
    current_entity_id = 0
}

function Entities.create_entity()
    -- returns an integer id
    Entities.current_entity_id += 1
    return Entities.current_entity_id
end
