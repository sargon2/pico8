Circuits = {}

function Circuits_recalculate()
    -- Panels provide power so really anything hooked up to a panel & wire should be powered, but
    -- for the purposes of determining if a panel is "powered" (that is, generating to the grid)
    -- it needs to be on a circuit that contains at least one transformer which is plugged into the central grid.
    -- That means we have phases:
    -- 1. determine circuit components and what's on them
    -- 2. determine which transformers are "powered" (i.e. connected to the grid)
    -- - If any component other than a transformer is plugged into the grid, it's not powered
    -- 3. a panel is powered if it's on a circuit with:
    -- - enough powered transformers
    -- - NOT the grid

    PerfTimer_time("Circuits_recalculate() (only when editing)", function()
        local grid_components, components = Circuits_get_connected_components()

        Attr_powered_grid = NewObj(BooleanGrid)
        Transformers_clear_overloaded()

        Circuits_mark_powered_transformers(grid_components) 

        Circuits_mark_powered_panels(components)
    end)
end

function Circuits_mark_powered_panels(components)
    local total_powered_panels = 0

    for component in all(components) do
        local num_powered_transformers = 0
        local num_panels = 0

        -- we need to avoid double-counting transformers that have both left & right on the same wire
        -- first, consolidate all the right-side transformers into lefts
        if component[Entities_Transformers_right] then
            for x, ys in pairs(component[Entities_Transformers_right]) do
                for y, t in pairs(ys) do
                    if t then
                        set_with_ensure(component, Entities_Transformers_left, x-1, y, true)
                    end
                end
            end
        end

        -- count powered transformers
        if component[Entities_Transformers_left] then
            for x, ys in pairs(component[Entities_Transformers_left]) do
                for y, t in pairs(ys) do
                    if t then
                        if Attr_powered_grid:is_set(x, y) then
                            num_powered_transformers += 1
                        end
                    end
                end
            end
        end

        if component[Entities_Panels] then
            -- count panels
            for _, ys in pairs(component[Entities_Panels]) do
                for _, t in pairs(ys) do
                    if t then
                        num_panels += 1
                    end
                end
            end

            -- check if transformers are overloaded
            if num_panels / num_powered_transformers <= Settings_max_panels_per_transformer then
                for x, ys in pairs(component[Entities_Panels]) do
                    for y, t in pairs(ys) do
                        if t then
                            if not Attr_powered_grid:is_set(x, y) then
                                Attr_powered_grid:set(x, y)
                                total_powered_panels += 1
                            end
                        end
                    end
                end
            else
                -- Transformers are overloaded
                for x, ys in pairs(component[Entities_Transformers_left]) do
                    for y, t in pairs(ys) do
                        if t then
                            Transformers_mark_overloaded(x, y)
                        end
                    end
                end
            end
        end
    end

    PanelCalculator_set_powered_panel_count(total_powered_panels)
end

function Circuits_mark_powered_transformers(grid_components)
    for component in all(grid_components) do
        for x, ys in pairs(component[Entities_Transformers_left]) do
            for y, t in pairs(ys) do
                if t then
                    Transformers_mark_powered(x, y)
                end
            end
        end
        for x, ys in pairs(component[Entities_Transformers_right]) do
            for y, t in pairs(ys) do
                if t then
                    Transformers_mark_powered(x-1, y)
                end
            end
        end
    end
end

function Circuits_get_connected_components()
    -- both of these are components[ent_id][x] = {y1, y2, ...}
    local grid_components = {}
    local components = {}

    local visited = NewObj(BooleanGrid)

    local current_component = {}

    local function visit(x, y)
        if visited:is_set(x, y) then
            -- Already visited this location
            return
        end
        -- What entity type are we?
        local ent_id = Locations_entity_at(x, y, true)
        if ent_id != nil then
            if Attr_is_circuit_component[ent_id] then
                -- If it's a circuit component, add it to the list of connected entities for this graph component
                set_with_ensure(current_component, ent_id, x, y, true)
            elseif ent_id == Entities_Wire or ent_id == Entities_GridWire then
                -- If it's wire or gridwire, continue recursing
                visited:set(x, y)
                visit(x-1, y)
                visit(x+1, y)
                visit(x,y-1)
                visit(x,y+1)
            end
        end
    end

    local function collect_components(target, ent_id)
        for t in Locations_iterate_all_entity_locations(ent_id) do
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

    collect_components(grid_components, Entities_GridWire)
    collect_components(components, Entities_Wire)

    return grid_components, components
end
