Modes = {}

-- A mode is just a set of systems.  Note that systems may be used in more than one mode.

-- The order here is the order in which systems will be loaded.
Mode_Overworld = {Rocks, Trees, Panels, Wire, GridWire, Transformers, Fence, Button, World, Cows, Inventory, Placement, Character, PanelCalculator}
Mode_SallysHouse = {IndoorWorld, Character}

local CurrentMode = nil

function Modes__disable_mode(mode)
    for s in all(mode) do
        disable_system(s)
    end
end

function Modes__enable_mode(mode)
    CurrentMode = mode
    for s in all(mode) do
        enable_system(s)
    end
end

function Modes_switch_mode(mode) -- Convenience
    Modes__disable_mode(CurrentMode)
    Modes__enable_mode(mode)
end
