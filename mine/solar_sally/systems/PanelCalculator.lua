
-- Calculates:
-- - Total electricity generation (watts)
-- - Total electricity out (watt-hours)
-- - Earning ($/h)
-- - Total earned ($)

PanelCalculator = {
    total_generation = 0, -- watts
    total_generated = 0, -- watt-hours
    earning = 0, -- $/h
    earned = 0, -- $
}

function PanelCalculator.init()
    PanelCalculator.total_generation = df_double({"+", "0", 0})
    PanelCalculator.total_generated = df_double({"+", "0", 0})
    PanelCalculator.earning = df_double({"+", "0", 0})
    PanelCalculator.earned = df_double({"+", "0", 0})
end

function PanelCalculator.draw()
    print("total generation: "..df_tostr(PanelCalculator.total_generation).."000 watts")
    print("total generated: "..df_tostr(PanelCalculator.total_generated).." kilowatt-hours")
    print("earning: $"..df_tostr(PanelCalculator.earning).."/h")
    print("earned: $"..df_tostr(PanelCalculator.earned))
end

function PanelCalculator.update(elapsed)
    -- We need to get the total number of powered panels.
    -- For now, we'll just get the number of panels.  TODO update this to only powered panels.
    local num_panels = Panels.getNumPanels()
    local elapsed_hours = df_divide(df_double(elapsed), df_double(3600)) -- convert seconds to hours

    PanelCalculator.total_generation = df_double(num_panels) -- 1000 watts per panel
    PanelCalculator.total_generated = df_add(PanelCalculator.total_generated, df_multiply(elapsed_hours, PanelCalculator.total_generation))

    PanelCalculator.earning = df_divide(PanelCalculator.total_generation, df_double("20000")) -- wattage / 1000000 to get MW, then * $50 to get 20,000
    PanelCalculator.earned = df_add(PanelCalculator.earned, df_multiply(elapsed_hours, PanelCalculator.earning))
end
