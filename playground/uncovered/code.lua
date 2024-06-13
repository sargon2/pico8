
grid = {}
player_x = 0
player_y = 0
overall_seed = nil
last_failed_x = nil
last_failed_y = nil

--[[const]] grid_size_x = 10
--[[const]] grid_size_y = 10
--[[const]] grid_scale = 6
--[[const]] grid_top = 10
--[[const]] grid_left = 20

local solution = {} -- soln[x][y] = {{x1, y1}, {x2, y2}, ...}

function wait_for_btn_down(b) -- works even between frames
    -- Wait for btn up
    while btn(b) do end

    -- Wait for btn down
    while not btn(b) do end
end

function render_solution(soln)
    for x, ys in pairs(soln) do
        for y, items in pairs(ys) do
            for item in all(items) do
                local ix, iy = unpack(item)
                grid_rectfill(ix, iy, 7)
            end
            grid_rectfill(x, y, 8)
            wait_for_btn_down(❎)
        end
    end
end

function make_zero_grid()
    local g = {}
    for i=0,grid_size_x-1 do
        g[i] = {}
        for j=0,grid_size_y-1 do
            g[i][j] = 0
        end
    end
    return g
end

function _init()
    -- Start in the lower left
    player_x = 0
    player_y = grid_size_y - 1

    -- Srand is already called with something random.  So to get a random initial seed, we can just:
    overall_seed = rnd()
    solution = build_solution()

    local show_solution = false
    if show_solution then
        cls()
        draw_board()
        render_solution(solution)
        wait_for_btn_down(❎)
    end

    grid = make_zero_grid()
end

function grid_rectfill(x, y, color)
    rectfill(grid_left+x*grid_scale+1, grid_top+y*grid_scale+1, grid_left+(x+1)*grid_scale-1, grid_top+(y+1)*grid_scale-1, color)
end

function draw_board()
    for i=0,grid_size_y do
        line(grid_left, grid_top+i*grid_scale, grid_left + grid_scale * grid_size_x, grid_top+i*grid_scale, 6)
    end
    for i=0,grid_size_x do
        line(grid_left+i*grid_scale, grid_top, grid_left+i*grid_scale, grid_top+grid_scale*grid_size_y, 6)
    end
end

function _draw()
    cls(0)

    draw_board()

    -- Draw the square fills
    for x=0,grid_size_x-1 do
        for y=0,grid_size_y-1 do
            if grid[x][y] == 1 then
                grid_rectfill(x, y, 7)
            elseif grid[x][y] == 2 then
                grid_rectfill(x, y, 9)
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
        if has_solution(player_x, player_y) then
            unfold_solution(player_x, player_y)
        else
            local seed = overall_seed + (player_x * grid_size_y + player_y)
            srand(seed)
            local result = try(player_x, player_y, false)
            if result == nil then
                -- Reset seed to reproduce pattern
                srand(seed)
                try(player_x, player_y, true)
            else
                -- Failed!
                last_failed_x, last_failed_y = unpack(result)
                player_x, player_y = start_x, start_y -- Undo the movement
            end
        end
    end
end

function random_spot()
    return flr(rnd(grid_size_x)), flr(rnd(grid_size_y))
end

function on_boundary(g, x, y)
    if(g[x][y] != 0) return false
    if(x < grid_size_x-1 and g[x+1][y] != 0) return true
    if(x > 0 and g[x-1][y] != 0) return true
    if(y < grid_size_y-1 and g[x][y+1] != 0) return true
    if(y > 0 and g[x][y-1] != 0) return true
    return false
end

function grow_spot(g, x, y) -- Writes to g, returns list of spots it changed
    --[[const]] local grow_spot_chance = 0.5 -- 0.25
    if(g[x][y] == 1) return

    local ret = {{x, y}}
    g[x][y] = 1

    local grown_by
    if x > 0 and rnd() < grow_spot_chance then
        grown_by = grow_spot(g, x-1, y)
        for item in all(grown_by) do
            add(ret, item)
        end
    end

    if x < grid_size_x-1 and rnd() < grow_spot_chance then
        grown_by = grow_spot(g, x+1, y)
        for item in all(grown_by) do
            add(ret, item)
        end
    end

    if y > 0 and rnd() < grow_spot_chance then
        grown_by = grow_spot(g, x, y-1)
        for item in all(grown_by) do
            add(ret, item)
        end
    end

    if y < grid_size_y-1 and rnd() < grow_spot_chance then
        grown_by = grow_spot(g, x, y+1)
        for item in all(grown_by) do
            add(ret, item)
        end
    end
    return ret
end

function build_solution()
    local soln_grid = make_zero_grid()
    --[[const]] local target_square_count = grid_size_x * grid_size_y
    local current_squares = 0
    local soln = {}

    while current_squares != target_square_count do
        -- Select a random spot on a boundary, or if it's the first time use the player starting position
        spot_x, spot_y = 0, grid_size_y-1
        if current_squares != 0 then
            -- Make sure it's on a boundary
            while not on_boundary(soln_grid, spot_x, spot_y) do
                spot_x, spot_y = random_spot()
            end
        end

        -- Grow that spot without overlapping
        local spot_list = grow_spot(soln_grid, spot_x, spot_y)
        current_squares += #spot_list

        -- Add to ret
        if(soln[spot_x] == nil) soln[spot_x] = {}
        soln[spot_x][spot_y] = spot_list
    end
    return soln
end

function has_solution(x, y)
    if(solution[x] == nil) return false
    if(solution[x][y] == nil) return false
    return true
end

function unfold_solution(x, y)
    grid[x][y] = 2
    local soln = solution[x][y]
    for item in all(soln) do
        local soln_x, soln_y = unpack(item)
        grid[soln_x][soln_y] = 2
    end
end

function try(x, y, execute) -- returns nil if success, {x, y} if failure -- TODO name

    --[[const]] local rand_grow_chance = 0.25

    if not execute and grid[x][y] != 0 then
        return {x, y}
    end

    local r
    if x > 0 and rnd() < rand_grow_chance then
        r = try(x-1, y, execute)
        if(r != nil) return r
    end

    if x < grid_size_x-1 and rnd() < rand_grow_chance then
        r = try(x+1, y, execute)
        if(r != nil) return r
    end

    if y > 0 and rnd() < rand_grow_chance then
        r = try(x, y-1, execute)
        if(r != nil) return r
    end

    if y < grid_size_y-1 and rnd() < rand_grow_chance then
        r = try(x, y+1, execute)
        if(r != nil) return r
    end

    if(execute) grid[x][y] = 1
    return nil
end
