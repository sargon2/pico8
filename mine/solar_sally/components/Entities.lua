Entities = {
    current_entity_id = 0
}

function Entities.create_entity()
    -- returns an integer id
    Entities.current_entity_id += 1
    return Entities.current_entity_id
end
