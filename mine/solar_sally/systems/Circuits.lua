Circuits = {}

function init()
    Circuits.is_powered_by_loc = BooleanGrid:new()
end

function Circuits.recalculate()
    -- Panels provide power so really anything hooked up to a panel & wire should be powered, but
    -- for the purposes of determining if a panel is "powered" (that is, generating to the grid)
    -- it needs to be on a circuit that contains at least one transformer which is plugged into the central grid.
    -- That means we need phases:
    -- 1. (done) determine circuit components and what's on them
    -- 2. determine which transformers are "powered" (i.e. connected to the grid)
    -- - If any component other than a transformer is plugged into the grid, it's not powered
    -- 3. a panel is powered if it's on a circuit with:
    -- - enough powered transformers
    -- - NOT the grid

    -- TODO:
    -- 1. (done) Add a sprite for "the grid" wire
    -- 1. (done) add an entity for "the grid" wire and add one or more into the world
    -- 1. (later) Sally's house should be connected to "the grid"
    -- 1. implement above phases

    local components = get_connected_components()

    mark_powered_transformers(components)

    printh(dump(components))
end

function mark_powered_transformers(components)
    -- TODO This would be easier if we had different entity ids for each transformer in the world.  Should we?
end

function get_connected_components()
    local components = {}

    local visited = BooleanGrid:new()
    local current_component = table_with_default_val(0)

    function visit(x, y)
        if visited:is_set(x, y) then
            -- Already visited this location
            return
        end
        visited:set(x, y)
        -- What entity type are we?
        local ent_id = Locations.entity_at(x, y)
        if ent_id != nil then
            if Attributes.get_attr(ent_id, "connectable") then
                -- If it's connectable, add it to the list of connected entities for this component
                current_component[ent_id] += 1
            elseif ent_id == Wire.ent_id or ent_id == GridWire.ent_id then
                -- If it's wire or gridwire, visit all our neighbors
                visit(x-1, y)
                visit(x+1, y)
                visit(x,y-1)
                visit(x,y+1)
            end
        end
    end

    for t in Locations.iterate_all_entity_locations({Wire.ent_id, GridWire.ent_id}) do
        local x = t[1]
        local y = t[2]

        if not visited:is_set(x, y) then
            visit(x, y) -- Will visit the entire component

            if next(current_component) != nil then -- if it's not empty
                add(components, current_component)
            end
            current_component = table_with_default_val(0)
        end
    end

    return components
end

function Circuits.is_powered(x, y)
    return Circuits.is_powered_by_loc[x][y]
end