Inventory = {
    -- TODO this needs to be ordered
    items = {}, -- items[ent_id] = count
}

function Inventory.init()
    -- Since we haven't implemented buying yet, just start with some core components.
    Inventory.items[Panels.ent_id] = 50
    Inventory.items[Transformers.ent_left] = 1
    Inventory.items[Wire.ent_id] = 100 -- TODO should wire be infinite?
end

function Inventory.add(ent_id)
    Inventory.items[ent_id] += 1
end

function Inventory.num_items() -- Lua is dumb
    local count = 0
    for _, _ in pairs(Inventory.items) do
        count += 1
    end
    return count
end

function Inventory.check_and_remove(ent_id)
    -- Returns ent id if succeeded, nil otherwise
    if Inventory.items[ent_id] and Inventory.items[ent_id] > 0 then
        Inventory.items[ent_id] -= 1
        return ent_id
    end
    return nil
end

function draw_window(x, y, width, height) -- TODO where should this live?
    Sprites.draw_relative_to_screen(Sprite_ids["window_ul"], x, y)
    for i = x+1,x+width-2 do
        Sprites.draw_relative_to_screen(Sprite_ids["window_u"], i, y)
    end
    Sprites.draw_relative_to_screen(Sprite_ids["window_ur"], x+width-1, y)

    for j = y+1,y+height-2 do
        Sprites.draw_relative_to_screen(Sprite_ids["window_l"], x, j)
        for i = x+1,x+width-2 do
            Sprites.draw_relative_to_screen(Sprite_ids["window_m"], i, j)
        end
        Sprites.draw_relative_to_screen(Sprite_ids["window_r"], x+width-1, j)
    end

    Sprites.draw_relative_to_screen(Sprite_ids["window_bl"], x, y+height-1)
    for i = x+1,x+width-2 do
        Sprites.draw_relative_to_screen(Sprite_ids["window_b"], i, y+height-1)
    end
    Sprites.draw_relative_to_screen(Sprite_ids["window_br"], x+width-1, y+height-1)
end

function print_text(text, x, y) -- TODO where should this live?
    print(text, x*8, y*8)
end

function Inventory.draw()
    local num_items = Inventory.num_items()
    -- TODO ui paper prototyping to tell where this window should go
    draw_window(12, 3, 4, num_items + 2)
    local row = 0
    -- TODO draw the sprite for each ent_id
    for ent_id, count in pairs(Inventory.items) do
        color(4)
        print_text(count, 13, 4+row)
        row += 1
    end
end
