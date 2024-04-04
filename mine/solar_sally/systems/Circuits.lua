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

    printh(dump(components))

    local powered_transformers = mark_powered_transformers(components)

    printh(dump(powered_transformers))
end

function mark_powered_transformers(components)
    local powered_transformers = BooleanGrid:new()

    for component in all(components) do
        -- TODO this is failing because GridWire is not connectable.  We can't make it connectable because you can put a transformer directly next to grid wire, and have a component without any regular wire.
        -- So, the fix is probably for the 'components' data structure to include whether or not each component contains grid wire or not.
        -- Maybe get_grid_component() should be separate from get_connected_components().
        if is_grid_component(component) then -- if this component is connected to the grid; there's only ever 1 grid component
            for x, y in pairs(components[Transformers.ent_left]) do
                powered_transformers:set(x, y)
                powered_transformers:set(x+1, y)
            end
            for x, y in pairs(components[Transformers.ent_right]) do
                powered_transformers:set(x, y)
                powered_transformers:set(x-1, y)
            end
        end
    end
    return powered_transformers
end

function get_connected_components()
    local components = {}

    local visited = BooleanGrid:new()
    local current_component = {}

    function visit(x, y)
        if visited:is_set(x, y) then
            -- Already visited this location
            return
        end
        -- What entity type are we?
        local ent_id = Locations.entity_at(x, y)
        if ent_id != nil then
            if Attributes.get_attr(ent_id, "connectable") then
                -- If it's connectable, add it to the list of connected entities for this component
                if(not current_component[ent_id]) current_component[ent_id] = {}
                if(not current_component[ent_id][x]) current_component[ent_id][x] = {}
                add(current_component[ent_id][x], y)
            elseif ent_id == Wire.ent_id or ent_id == GridWire.ent_id then
                -- If it's wire or gridwire, continue recursing
                visited:set(x, y)
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
            current_component = {}
        end
    end

    return components
end

function Circuits.is_powered(x, y)
    return Circuits.is_powered_by_loc[x][y]
end