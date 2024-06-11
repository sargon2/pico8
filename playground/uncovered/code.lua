
grid = {}
player_x = 0
player_y = 9
overall_seed = nil
last_failed_x = nil
last_failed_y = nil

--[[const]] grid_size_x = 30
--[[const]] grid_size_y = 30
--[[const]] grid_scale = 3
--[[const]] grid_top = 10
--[[const]] grid_left = 20

function _init()
    -- Srand is already called with something random.  So to get a random initial seed, we can just
    overall_seed = rnd()
    for i=0,grid_size_x-1 do
        grid[i] = {}
        for j=0,grid_size_y-1 do
            grid[i][j] = 0
        end
    end
    grid[player_x][player_y] = 1
end

function grid_rectfill(x, y, color)
    rectfill(grid_left+x*grid_scale+1, grid_top+y*grid_scale+1, grid_left+(x+1)*grid_scale-1, grid_top+(y+1)*grid_scale-1, color)
end

function _draw()
    cls(0)
    -- Draw the board
    for i=0,grid_size_y do
        line(grid_left, grid_top+i*grid_scale, grid_left + grid_scale * grid_size_x, grid_top+i*grid_scale, 6)
    end
    for i=0,grid_size_x do
        line(grid_left+i*grid_scale, grid_top, grid_left+i*grid_scale, grid_top+grid_scale*grid_size_y, 6)
    end

    -- Draw the square fills
    for x=0,grid_size_x-1 do
        for y=0,grid_size_y-1 do
            if grid[x][y] == 1 then
                grid_rectfill(x, y, 7)
            end
        end
    end

    -- Draw the player
    grid_rectfill(player_x, player_y, 8)

    -- Draw last failed
    if last_failed_x != nil then
        grid_rectfill(last_failed_x, last_failed_y, 10)
    end
end

function _update60()
    -- TODO disallow moving diagonally
    local start_x, start_y = player_x, player_y
    if btnp(⬅️) and player_x > 0 then
        player_x -= 1
    elseif btnp(➡️) and player_x < grid_size_x-1 then
        player_x += 1
    elseif btnp(⬆️) and player_y > 0 then
        player_y -= 1
    elseif btnp(⬇️) and player_y < grid_size_y-1 then
        player_y += 1
    end

    if grid[player_x][player_y] == 0 then
        local seed = overall_seed + (player_x * grid_size_y + player_y)
        srand(seed)
        local result = try(player_x, player_y, start_x, start_y, false)
        if result == nil then
            -- Reset seed to reproduce pattern
            srand(seed)
            try(player_x, player_y, start_x, start_y, true)
        else
            -- Failed!
            last_failed_x, last_failed_y = unpack(result)
            player_x, player_y = start_x, start_y -- Undo the movement
        end
    end
end

function try(x, y, sx, sy, execute) -- returns nil if success, {x, y} if failure
    if x == sx and y == sy then
        -- Don't select the square the player started on since it looks weird when that happens
        return nil
    end
    if not execute and grid[x][y] == 1 then
        return {x, y}
    end

    local r
    if x > 0 and rnd() < .25 then
        r = try(x-1, y, sx, sy, execute)
        if(r != nil) return r
    end

    if x < grid_size_x-1 and rnd() < .25 then
        r = try(x+1, y, sx, sy, execute)
        if(r != nil) return r
    end

    if y > 0 and rnd() < .25 then
        r = try(x, y-1, sx, sy, execute)
        if(r != nil) return r
    end

    if y < grid_size_y-1 and rnd() < .25 then
        r = try(x, y+1, sx, sy, execute)
        if(r != nil) return r
    end

    if(execute) grid[x][y] = 1
    return nil
end