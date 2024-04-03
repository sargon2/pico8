Circuits = {}

function init()
    Circuits.is_powered_by_loc = BooleanGrid.new()
end

function Circuits.recalculate()
    -- Panels provide power so really anything hooked up to a panel & wire should be powered, but
    -- for the purposes of determining if a panel is "powered" (that is, generating to the grid)
    -- it needs to be on a circuit that contains at least one transformer which is plugged into the central grid.
    -- That means we need phases:
    -- 1. determine circuit components and what's on them
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

    -- for t in Locations.iterate_all_entity_locations({Rocks.ent_id, GridWire.ent_id}) do
    --     printh(dump(t))
    -- end
end

function Circuits.is_powered(x, y)
    return Circuits.is_powered_by_loc[x][y]
end