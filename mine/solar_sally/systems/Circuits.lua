Circuits = {}

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

    local grid_components, components = Circuits.get_connected_components()

    Circuits.mark_powered_transformers(grid_components)

    Circuits.mark_powered_panels(components)
end

function Circuits.get_name()
    return "Circuits"
end

function Circuits.mark_powered_panels(components)
    Panels.clear_powered()

    local total_powered_panels = 0

    for component in all(components) do
        local num_powered_transformers = 0
        local num_panels = 0

        -- we need to avoid double-counting transformers that have both left & right on the same wire
        -- first, consolidate all the right-side transformers into lefts
        if component[Transformers.ent_right] then
            for x, ys in pairs(component[Transformers.ent_right]) do
                for y, t in pairs(ys) do
                    if t then
                        if(not component[Transformers.ent_left]) component[Transformers.ent_left] = {}
                        if(not component[Transformers.ent_left][x-1]) component[Transformers.ent_left][x-1] = {}
                        if(not component[Transformers.ent_left][x-1][y]) component[Transformers.ent_left][x-1][y] = {}
                        component[Transformers.ent_left][x-1][y] = true
                    end
                end
            end
        end

        -- count powered transformers
        if component[Transformers.ent_left] then
            for x, ys in pairs(component[Transformers.ent_left]) do
                for y, t in pairs(ys) do
                    if t then
                        if Transformers.is_powered(x, y) then
                            num_powered_transformers += 1
                        end
                    end
                end
            end
        end

        if component[Panels.ent_id] then
            -- count panels
            for _, ys in pairs(component[Panels.ent_id]) do
                for _, t in pairs(ys) do
                    if t then
                        num_panels += 1
                    end
                end
            end

            -- check if transformers are overloaded
            if num_panels / num_powered_transformers <= Settings.max_panels_per_transformer then
                for x, ys in pairs(component[Panels.ent_id]) do
                    for y, t in pairs(ys) do
                        if t then
                            if not Panels.is_powered(x, y) then
                                Panels.mark_powered(x, y)
                                total_powered_panels += 1
                            end
                        end
                    end
                end
            else
                -- Transformers are overloaded
                for x, ys in pairs(component[Transformers.ent_left]) do
                    for y, t in pairs(ys) do
                        if t then
                            Transformers.mark_overloaded(x, y)
                        end
                    end
                end
            end
        end
    end

    PanelCalculator.set_powered_panel_count(total_powered_panels)
end

function Circuits.mark_powered_transformers(grid_components)
    Transformers.clear_powered()

    for component in all(grid_components) do
        for x, ys in pairs(component[Transformers.ent_left]) do
            for y, t in pairs(ys) do
                if t then
                    Transformers.mark_powered(x, y)
                end
            end
        end
        for x, ys in pairs(component[Transformers.ent_right]) do
            for y, t in pairs(ys) do
                if t then
                    Transformers.mark_powered(x-1, y)
                end
            end
        end
    end
end

function Circuits.get_connected_components()
    -- both of these are components[ent_id][x] = {y1, y2, ...}
    local grid_components = {}
    local components = {}

    local visited = BooleanGrid:new()
    local current_component = {}

    local function visit(x, y)
        if visited:is_set(x, y) then
            -- Already visited this location
            return
        end
        -- What entity type are we?
        local ent_id = Locations.entity_at(x, y)
        if ent_id != nil then
            if Attributes.get_attr(ent_id, "is_circuit_component") then
                -- If it's a circuit component, add it to the list of connected entities for this graph component
                if(not current_component[ent_id]) current_component[ent_id] = {}
                if(not current_component[ent_id][x]) current_component[ent_id][x] = {}
                if(not current_component[ent_id][x][y]) current_component[ent_id][x][y] = {}
                current_component[ent_id][x][y] = true
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

    local function collect_components(target, ent_ids)
        for t in Locations.iterate_all_entity_locations(ent_ids) do
            local x = t[1]
            local y = t[2]

            if not visited:is_set(x, y) then
                visit(x, y) -- Will visit the entire component

                if next(current_component) != nil then -- if it's not empty
                    add(target, current_component)
                end
                current_component = {}
            end
        end
    end

    collect_components(grid_components, {GridWire.ent_id})
    collect_components(components, {Wire.ent_id})

    return grid_components, components
end
