
PanelCalculator = {
    name = "PanelCalculator",
    powered_panel_count = 0,
    earned = 0, -- $
    frame_counter = 0
}

function PanelCalculator.draw()
    color(6)
    print("earned: $"..sub(full_tostr(PanelCalculator.earned),1,8))
end

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
    PanelCalculator.earned += ((1 >> 16) * num_seconds) * PanelCalculator.powered_panel_count
end

function PanelCalculator.add_panel_8h(n) -- Add n 8-hour increments
    -- 28800*h may not fit inside a pico-8 number, so we must repeat.
    for i=1,n do
        PanelCalculator.add_panel_seconds(28800)
    end
end

function PanelCalculator.set_powered_panel_count(c)
    PanelCalculator.powered_panel_count = c
end