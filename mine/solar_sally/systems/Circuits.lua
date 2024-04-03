Circuits = {}

function init()
    Circuits.is_powered_by_loc = BooleanGrid.new()
end

function Circuits.recalculate()
    -- Panels provide power so really anything hooked up to a panel & wire should be powered, but
    -- for the purposes of determining if a panel is "powered" (that is, generating to the grid)
    -- it needs to be on a circuit that contains at least one transformer which is plugged into the central grid.
    -- That means we need phases:
    -- 1. determine circuit components and what's on them; transformers count as continuous wire
    -- 2. a panel is powered if it's on a circuit with:
    -- - enough transformers
    -- - the grid
end

function Circuits.is_powered(x, y)
    return Circuits.is_powered_by_loc[x][y]
end