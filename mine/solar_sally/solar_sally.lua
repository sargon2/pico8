
-- todo
-- add total electricity generated
-- add energy storage
-- add day/night cycle
-- add panel inventory
-- add money to buy panels
-- add store to buy panels from
-- add trees
-- add houses?

function _init()
    srand(12345)

    Rocks.init()
    Panels.init()
    Wire.init()
    Transformers.init()
    Placement.init()
end

function _draw()
    cls()
    map(0,0,64-(Character.x*8),64-(Character.y*8)) -- TODO should this be in draw_all as a Map component?

    Drawable.draw_all(Character.x, Character.y)

    -- TODO should these be in draw_all somehow?
    Character.draw(64, 64)
    Placement.draw_selection()
end

function _update60()
    local elapsed = FrameTimer.calculate_elapsed()
    Character.handle_player_movement(elapsed)
    Placement.handle_selection_and_placement()
end
