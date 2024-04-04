ZValues = {
    -- We can't use ent ids here because:
    -- - We can't init this class before the others since their ent ids aren't set yet
    -- - We can't init the other classes before this one because their inits depend on z value
    Map = 1,
    Panels = 2,
    Rocks = 2,
    Transformers = 2,
    Wire = 2,
    GridWire = 2,
    Trees = 2,
    Character = 2,
    Placement = 3,
    PanelCalculator = 3
}

function ZValues.get_max()
    -- TODO actually calculate it
    return 3
end