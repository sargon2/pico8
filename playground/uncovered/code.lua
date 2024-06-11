
grid = {}
player_x = 0
player_y = 9

--[[const]] grid_size_x = 10
--[[const]] grid_size_y = 10
--[[const]] grid_scale = 6
--[[const]] grid_top = 10
--[[const]] grid_left = 20

function _init()
    for i=0,grid_size_x-1 do
        grid[i] = {}
        for j=0,grid_size_y-1 do
            grid[i][j] = 0
        end
    end
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
                rectfill(grid_left+x*grid_scale+1, grid_top+y*grid_scale+1, grid_left+(x+1)*grid_scale-1, grid_top+(y+1)*grid_scale-1, 7)
            end
        end
    end

    -- Draw the player
    rectfill(grid_left+player_x*grid_scale+1, grid_top+player_y*grid_scale+1, grid_left+(player_x+1)*grid_scale-1, grid_top+(player_y+1)*grid_scale-1, 8)
end

function _update60()
    if btnp(⬅️) and player_x > 0 then
        player_x -= 1
    end
    if btnp(➡️) and player_x < grid_size_x-1 then
        player_x += 1
    end
    if btnp(⬆️) and player_y > 0 then
        player_y -= 1
    end
    if btnp(⬇️) and player_y < grid_size_y-1 then
        player_y += 1
    end

    if grid[player_x][player_y] == 0 then
        grid[player_x][player_y] = 1
        grid[player_x][player_y-1] = 1
    end
end