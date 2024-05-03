
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
    systems = {Rocks, Trees, Panels, Wire, GridWire, Transformers, Button, World, Cows, Inventory, Placement, Character, PanelCalculator, fadetoblack, CoroutineRunner}
}

function system_is_loaded(s)
    -- TODO should we cache a boolean table to speed this up?
    return contains(solar_sally.systems, s)
end

function unload_system(s)
    del(solar_sally.systems, s)
end

function load_system(s) -- Careful! Order matters
    add(solar_sally.systems, s)
    if s.init then
        s.init()
    end
end

function _init()
    --srand(12345)

    for system in all(solar_sally.systems) do
        if system.init then
            system.init()
        end
    end
end

function _draw()
    cls()

    for system in all(solar_sally.systems) do
        if system.draw then
            PerfTimer.time(system.name..".draw()", function ()
                system.draw()
            end)
        end
    end
    if(Settings_debug_window) db_window()
    PerfTimer.reportTimes()
end

function do_update()
    local elapsed = FrameTimer_calculate_elapsed()

    for system in all(solar_sally.systems) do
        if system.update then
            PerfTimer.time(system.name..".update()", function ()
                system.update(elapsed)
            end)
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
