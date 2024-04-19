
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
    systems = {Rocks, Trees, Panels, Wire, GridWire, Transformers, Button, Map, World, Cows, Placement, Character, FrameTimer, PanelCalculator, Inventory}
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

    if(Settings_debug_timing) printh("\n\nDrawing; start "..tostr(PerfTimer.get_and_advance()))
    for system in all(solar_sally.systems) do
        if system.draw then
            system.draw()
            if(Settings_debug_timing) printh(system.get_name()..".draw(): "..tostr(PerfTimer.get_and_advance()))
        end
    end
    if(Settings_debug_window) db_window()
end

function do_update()
    local elapsed = FrameTimer_calculate_elapsed()

    if Settings_debug_timing then
        PerfTimer.reset()
        printh("\n\n\nUpdating; start "..tostr(PerfTimer.get_and_advance()))
    end
    for system in all(solar_sally.systems) do
        if system.update then
            system.update(elapsed)
            if(Settings_debug_timing) printh(system.get_name()..".update(): "..tostr(PerfTimer.get_and_advance()))
        end
    end
end

-- The debug tree window scroll wheel doesn't work at 60 fps, so if that's enabled, drop to 30.
if Settings_debug_window then
    function _update()
        do_update()
    end
else
    function _update60()
        do_update()
    end
end
