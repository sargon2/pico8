ZValues = {
    -- We can't use ent ids here because:
    -- - We can't init this class before the others since their ent ids aren't set yet
    -- - We can't init the other classes before this one because their inits depend on z value
    Map = 1,
    Panels = 2,
    Rocks = 3,
    Transformers = 4,
    Wire = 5,
    Character = 6,
    Placement = 7,
}
