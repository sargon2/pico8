Renderer = {}

function Renderer.draw()
    local xmin = flr(Character.x - 10)
    local xmax = flr(Character.x + 8)
    local ymin = flr(Character.y - 9)
    local ymax = flr(Character.y + 9)

    -- TODO should we make this some kind of generic mechanism so we don't hardcode Map and Placement? Like an ordered list of aggregate drawing functions.
    -- In fact, they could be called by the main system draw() loop.

    Map.drawMap()

    for y = ymin, ymax do
        for x = xmin, xmax do
            Sprites.draw(x,y,2)
            TileDrawFns.draw(x,y,2)
        end
        if y == flr(Character.y) then
            Character.drawChar()
        end
    end

    Placement.draw_selection()
end