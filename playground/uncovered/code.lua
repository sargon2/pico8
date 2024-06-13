
grid = {}
-- grid value meanings:
-- 0 unvisited/black
-- 1 random unfolded
-- 2 solution unfolded

player_x = 0
player_y = 0
overall_seed = nil
last_failed_x = nil
last_failed_y = nil

--[[const]] grid_size_x = 10
--[[const]] grid_size_y = 10
--[[const]] grid_scale = 8
--[[const]] grid_top = 10
--[[const]] grid_left = 20

local solution = {} -- soln[x][y] = {{x1, y1}, {x2, y2}, ...}
local path = {} -- {{x1, y1}, {x2, y2}, ...}
local unfolded = {} -- {{{unfold1_x1, unfold1_y1}, {unfold1_x2, unfold1_y2}, ...}, {{unfold2_x1, unfold2_y1}, {unfold2_x2, unfold2_y2}, ...}, ...}

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

    -- Draw visited squares
    for coord in all(path) do
        local vx, vy = unpack(coord)
        grid_rectfill(vx, vy, 15)
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

    if player_x != start_x or player_y != start_y then
        local last_loc = path[#path-1]
        if last_loc != nil then
            if last_loc[1] == player_x and last_loc[2] == player_y then
                last_failed_x, last_failed_y = nil, nil
                path = slice_tbl(path, 1, #path-1)
                for coord in all(unfolded[#unfolded]) do
                    local undo_x, undo_y = unpack(coord)
                    grid[undo_x][undo_y] = 0
                end
                unfolded = slice_tbl(unfolded, 1, #unfolded-1)
                return -- avoid adding to path/unfolded when undoing
            end
        end
    end

    if grid[player_x][player_y] == 0 then
        if has_solution(player_x, player_y) then
            local result = try_unfold_solution(player_x, player_y)
            if result == nil then
                local changed = unfold_solution(player_x, player_y)
                add(path, {player_x, player_y})
                add(unfolded, changed)
            else
                -- Failed!
                last_failed_x, last_failed_y = unpack(result)
                player_x, player_y = start_x, start_y -- Undo the movement
            end
        else
            local seed = overall_seed + (player_x * grid_size_y + player_y)
            srand(seed)
            local result = try(player_x, player_y)
            if result == nil then
                -- Reset seed to reproduce pattern
                srand(seed)
                local changed = try_execute(player_x, player_y)
                add(unfolded, changed)
                add(path, {player_x, player_y})
            else
                -- Failed!
                last_failed_x, last_failed_y = unpack(result)
                player_x, player_y = start_x, start_y -- Undo the movement
            end
        end
    else
        if player_x != start_x or player_y != start_y then
            add(path, {player_x, player_y})
            add(unfolded, {})
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

function try_unfold_solution(x, y) -- returns nil if clear, coord if collision -- TODO dup'd with unfold_solution
    local ret = {}
    local soln = solution[x][y]
    for item in all(soln) do
        local soln_x, soln_y = unpack(item)
        if(grid[soln_x][soln_y] != 0) return {soln_x, soln_y}
    end
    return nil
end

function unfold_solution(x, y)
    local ret = {}
    local soln = solution[x][y]
    for item in all(soln) do
        local soln_x, soln_y = unpack(item)
        grid[soln_x][soln_y] = 2
        add(ret, {soln_x, soln_y})
    end
    return ret
end

function try_execute(x, y) -- executes; returns list of coords turned on -- TODO name -- TODO duplicated with try
    --[[const]] local rand_grow_chance = 0.25

    local ret = {}

    if x > 0 and rnd() < rand_grow_chance then
        add_all(ret, try(x-1, y))
    end

    if x < grid_size_x-1 and rnd() < rand_grow_chance then
        add_all(ret, try(x+1, y))
    end

    if y > 0 and rnd() < rand_grow_chance then
        add_all(ret, try(x, y-1))
    end

    if y < grid_size_y-1 and rnd() < rand_grow_chance then
        add_all(ret, try(x, y+1))
    end

    if grid[x][y] == 0 then
        grid[x][y] = 1
        add(ret, {x, y})
    end
    return ret
end

function try(x, y) -- returns nil if success, {x, y} if failure -- TODO name

    --[[const]] local rand_grow_chance = 0.25

    if grid[x][y] != 0 then
        return {x, y}
    end

    local r
    if x > 0 and rnd() < rand_grow_chance then
        r = try(x-1, y)
        if(r != nil) return r
    end

    if x < grid_size_x-1 and rnd() < rand_grow_chance then
        r = try(x+1, y)
        if(r != nil) return r
    end

    if y > 0 and rnd() < rand_grow_chance then
        r = try(x, y-1)
        if(r != nil) return r
    end

    if y < grid_size_y-1 and rnd() < rand_grow_chance then
        r = try(x, y+1)
        if(r != nil) return r
    end

    return nil
end
