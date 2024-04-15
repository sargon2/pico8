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
    local function _draw_spr(sprite_name, x, y)
        Sprites.draw_relative_to_screen(Sprite_ids[sprite_name], x, y)
    end

    _draw_spr("window_ul", x, y)
    for i = x+1,x+width-2 do
        _draw_spr("window_u", i, y)
    end
    _draw_spr("window_ur", x+width-1, y)

    for j = y+1,y+height-2 do
        _draw_spr("window_l", x, j)
        for i = x+1,x+width-2 do
            _draw_spr("window_m", i, j)
        end
        _draw_spr("window_r", x+width-1, j)
    end

    _draw_spr("window_bl", x, y+height-1)
    for i = x+1,x+width-2 do
        _draw_spr("window_b", i, y+height-1)
    end
    _draw_spr("window_br", x+width-1, y+height-1)
end

function print_text(text, x, y, xoffset, yoffset) -- TODO where should this live?
    print(text, x*8+xoffset, y*8+yoffset)
end

function Inventory.draw()
    local num_items = Inventory.num_items()
    -- TODO ui paper prototyping to tell where this window should go
    draw_window(12, 3, 4, num_items + 2)
    local row = 0
    for ent_id, count in pairs(Inventory.items) do
        DrawFns.drawTileAt(ent_id, 13, 4+row, true)
        color(4)
        print_text(count, 14, 4+row, 2, 2)
        row += 1
    end
    -- What order should we display them in?
    -- - A hardcoded order
    -- - Alphabetical
    -- - Should this code even be generic enough to handle any inventory items? Or should it just be fully hardcoded?
    -- - Why not have a hardcoded list, then "other" which is alphabetical?
    -- - If the player doesn't have a certain item, should it display it with a 0? Or just leave it off the list?

end
