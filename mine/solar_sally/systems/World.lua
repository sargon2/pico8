World = {}

function World.draw()
    local xmin = flr(Character.x - 10)
    local xmax = flr(Character.x + 8)
    local ymin = flr(Character.y - 9)
    local ymax = flr(Character.y + 9)

    for y = ymin, ymax do
        for x = xmin, xmax do
            Sprites.draw(x,y)
            TileDrawFns.draw(x,y)
        end
        if y == flr(Character.y+.4) then
            Character.drawChar()
        end
    end
end