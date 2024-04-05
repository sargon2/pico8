
-- todo
-- add total electricity generated
-- add energy storage
-- add day/night cycle
-- add panel inventory
-- add money to buy panels
-- add store to buy panels from
-- add trees
-- add houses?

solar_sally = {
    -- The order here is important (think dep injection dependency graph)
    -- Includes entities as well as systems; anything that needs to be init'd
    systems = {Rocks, Trees, Panels, Wire, GridWire, Transformers, Map, World, Cows, Placement, Character, FrameTimer, PanelCalculator}
}

function _init()
    srand(12345)

    for system in all(solar_sally.systems) do
        if system.init then
            system.init()
        end
    end

    Circuits.recalculate() -- TODO remove
end

function _draw()
    cls()

    if(Settings.debug_timing) printh("Drawing; start "..tostr(PerfTimer.get_and_advance()))
    for system in all(solar_sally.systems) do
        if system.draw then
            system.draw()
            if(Settings.debug_timing) printh(system.get_name()..".draw(): "..tostr(PerfTimer.get_and_advance()))
        end
    end
end

function _update60()
    local elapsed = FrameTimer.calculate_elapsed()

    if Settings.debug_timing then
        PerfTimer.reset()
        printh("")
        printh("Updating; start "..tostr(PerfTimer.get_and_advance()))
    end
    for system in all(solar_sally.systems) do
        if system.update then
            system.update(elapsed)
            if(Settings.debug_timing) printh(system.get_name()..".update(): "..tostr(PerfTimer.get_and_advance()))
        end
    end
end
