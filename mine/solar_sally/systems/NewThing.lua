-- TODO name this

NewThing = {
    name = "NewThing"
}

function NewThing.init()
    SmoothLocations_set_or_update_location(Entities_Character, 8, 8)
end

function NewThing.draw()
    map(0,0,16,16)
    Character.drawChar()
end

-- TODO:
-- - (Done) Extract all Placement code into a separate function in Character.
-- - (Done) Move that new function into Placement.
-- - (Done) Make it so when Placement isn't loaded, we don't get the Placement movement delay on the character.
-- - Get the character to visually move when moved in this mode.
-- - Character is calling spr() directly.  Should it call Sprites_draw_spr() instead?
-- - Is this NewThing ScreenRelativeCharacterWorld? House? ScreenRelativeWorld?
-- - Trigger the mode change to this mode from a script.
-- - We need house sprites.
