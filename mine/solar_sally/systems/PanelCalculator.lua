
-- Calculates:
-- - Total electricity generation (watts)
-- - Total electricity out (watt-hours)
-- - Earning ($/h)
-- - Total earned ($)

PanelCalculator = {
    capacity = 0, -- watts
    total_generated = 0, -- watt-hours
    earning = 0, -- $/h
    earned = 0, -- $
}

function PanelCalculator.init()
    PanelCalculator.capacity = df_double({"+", "0", 0})
    PanelCalculator.total_generated = df_double({"+", "0", 0})
    PanelCalculator.earning = df_double({"+", "0", 0})
    PanelCalculator.earned = df_double({"+", "0", 0})
end

function df_and_trim(val, digits)
    if not digits then
        digits = 10
    end
    return sub(df_tostr(val), 1, digits)
end

function PanelCalculator.draw()
    color(6)
    print("capacity: "..df_and_trim(PanelCalculator.capacity).."000 watts")
    print("total: "..df_and_trim(PanelCalculator.total_generated, 6).." watt-hours")
    print("earning: $"..df_and_trim(PanelCalculator.earning).."/h")
    print("earned: $"..df_and_trim(PanelCalculator.earned))
end

function PanelCalculator.update(elapsed)
    -- We need to get the total number of powered panels.
    -- For now, we'll just get the number of panels.  TODO update this to only powered panels.
    local num_panels = Locations.count_placed(Panels.ent_id)
    local elapsed_hours = df_divide(df_double(elapsed), df_double(3600)) -- convert seconds to hours

    PanelCalculator.capacity = df_double(num_panels) -- 1000 watts per panel
    PanelCalculator.total_generated = df_add(PanelCalculator.total_generated, df_multiply(elapsed_hours, PanelCalculator.capacity))

    PanelCalculator.earning = df_divide(PanelCalculator.capacity, df_double("20000")) -- wattage / 1000000 to get MW, then * $50 to get 20,000
    PanelCalculator.earned = df_add(PanelCalculator.earned, df_multiply(elapsed_hours, PanelCalculator.earning))
end
