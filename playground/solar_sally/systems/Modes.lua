Modes = {}

-- A mode is just a set of systems.  Note that systems may be used in more than one mode.

Mode_Overworld = {World, Placement, Cows, Trees}
Mode_SallysHouse = {IndoorWorld}
local Mode_all_modes = {Mode_Overworld, Mode_SallysHouse}

local CurrentMode = Mode_Overworld -- Initial mode

function Modes.on_load()
    -- Modes that are disabled on startup
    for mode in all(Mode_all_modes) do
        if(mode != CurrentMode) Modes__disable_mode(mode)
    end
end

function Modes__disable_mode(mode)
    for s in all(mode) do
        disable_system(s)
    end
end

function Modes__enable_mode(mode)
    for s in all(mode) do
        enable_system(s)
    end
end

function Modes_switch_mode(mode)
    Modes__disable_mode(CurrentMode)
    CurrentMode = mode
    Modes__enable_mode(mode)
end
