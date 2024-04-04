
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
    systems = {Drawable, Rocks, Trees, Panels, Wire, GridWire, Transformers, Placement, Character, Map, FrameTimer, PanelCalculator}
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

    for system in all(solar_sally.systems) do
        if system.draw then
            system.draw()
        end
    end
end

function _update60()
    local elapsed = FrameTimer.calculate_elapsed()

    for system in all(solar_sally.systems) do
        if system.update then
            system.update(elapsed)
        end
    end
end
