
PanelCalculator = {
    name = "PanelCalculator",
    powered_panel_count = 0,
    frame_counter = 0
}

function PanelCalculator.update(elapsed)
    PanelCalculator.frame_counter += flr((elapsed * 60) + 0.5)
    while PanelCalculator.frame_counter > 60 do
        -- a second went by
        PanelCalculator.add_panel_seconds(1)
        PanelCalculator.frame_counter -= 60
    end
end

function PanelCalculator.add_panel_seconds(num_seconds)
    -- The smallest unit of time we can advance is 1 second, and the smallest amount we can add to earned is 1 >> 16.
    Inventory_addMoney(
        ((1 >> 16) * num_seconds) * PanelCalculator.powered_panel_count
    )
end

function PanelCalculator.add_panel_years(y)
    for _=1,y do
        PanelCalculator.add_panel_days(365)
    end
    -- Deal with leap years
    PanelCalculator.add_panel_seconds(20926.08) -- .2422 days is 20926.08 seconds
end

function PanelCalculator.add_panel_days(d)
    PanelCalculator.add_panel_8h(d*3)
end

function PanelCalculator.add_panel_8h(n) -- Add n 8-hour increments
    -- 28800*h may not fit inside a pico-8 number, so we must repeat.
    for _=1,n do
        PanelCalculator.add_panel_seconds(28800)
    end
end

function PanelCalculator.set_powered_panel_count(c)
    PanelCalculator.powered_panel_count = c
end