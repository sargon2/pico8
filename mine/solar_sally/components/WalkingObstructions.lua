WalkingObstructions = {
    obstr = {}
}

-- TODO a lot in this file seems duplicated..

function WalkingObstructions.add_entity(ent_id)
    WalkingObstructions.obstr[ent_id] = true
end

function WalkingObstructions.obstructs(ent_id)
    return WalkingObstructions.obstr[ent_id]
end

function WalkingObstructions.obstructed(x, y)
    return WalkingObstructions.obstructs(Locations.entity_at(x, y))
end
