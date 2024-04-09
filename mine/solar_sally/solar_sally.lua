
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
    if(Settings.debug_window) db_window()
end

function do_update()
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

-- The debug tree window scroll wheel doesn't work at 60 fps, so if that's enabled, drop to 30.
if Settings.debug_window then
    function _update()
        do_update()
    end
else
    function _update60()
        do_update()
    end
end
