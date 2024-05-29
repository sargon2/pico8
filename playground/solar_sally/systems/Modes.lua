Modes = {}

-- A mode is just a set of systems.  Note that systems may be used in more than one mode.

--[[const]] Mode_Overworld = 1
--[[const]] Mode_SallysHouse = 2
--[[const]] Mode_SleepResults = 3
--[[const]] Mode_TitleScreen = 4
--[[const]] Mode_TitleScreenInterlude = 5

local Mode_systems = {} -- systems[mode] = {...}

local CurrentMode = nil
local PreviousMode = nil

function Modes.on_load()
    -- The order here is the order in which systems will be loaded.
    Mode_systems[Mode_Overworld] = {Rocks, Trees, Panels, Wire, GridWire, Transformers, Fence, Button, World, Cows, Inventory, Actions, Character, PanelCalculator}
    Mode_systems[Mode_SallysHouse] = {Panels, Wire, Transformers, IndoorWorld, Character, Inventory} -- panels/wire/transformers needed so we can render their inventory icons
    Mode_systems[Mode_SleepResults] = {SleepResults}
    Mode_systems[Mode_TitleScreen] = {TitleScreen}
    Mode_systems[Mode_TitleScreenInterlude] = {TitleScreenInterlude}
end

function Modes__disable_mode(mode)
    for s in all(Mode_systems[mode]) do
        disable_system(s)
    end
end

function Modes__enable_mode(mode)
    PreviousMode = CurrentMode
    CurrentMode = mode
    for s in all(Mode_systems[mode]) do
        enable_system(s)
    end
end

function Modes_switch_mode(mode) -- Convenience
    Modes__disable_mode(CurrentMode)
    Modes__enable_mode(mode)
end

function Modes_return_to_previous_mode()
    Modes_switch_mode(PreviousMode)
end