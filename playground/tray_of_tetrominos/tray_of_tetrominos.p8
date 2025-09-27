pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- tray of tetrominos
-- you're done playing tetris and want to put all the pieces away.
-- but, they have to fit in their storage tray!

-- todo:
-- upcoming pieces view
-- game over screen when it's impossible to continue
-- show button guide while playing
-- you win screen/music/sfx
-- title screen
-- music
-- lots of sfx
-- hidden palette for more accurate colors
-- lots of gfx effects

-- grid size
grid_w = 10
grid_h = 20

-- how big the grid is drawn
grid_size = 6

-- active piece number
local piece

-- active piece position
posx = 5
posy = 10

-- active piece rotation
rot = 0

-- each cell holds 0 (empty) or sprite index
grid = {}

pieces = {}

shapes = {
 { -- i
  {{-1,0},{0,0},{1,0},{2,0}},
  {{0,-1},{0,0},{0,1},{0,2}},
  {{-1,0},{0,0},{1,0},{2,0}},
  {{0,-1},{0,0},{0,1},{0,2}},
 },
 { -- j
  {{-1,-1},{-1,0},{0,0},{1,0}},
  {{0,-1},{1,-1},{0,0},{0,1}},
  {{-1,0},{0,0},{1,0},{1,1}},
  {{0,-1},{0,0},{-1,1},{0,1}},
 },
 { -- l
  {{1,-1},{-1,0},{0,0},{1,0}},
  {{0,-1},{0,0},{0,1},{1,1}},
  {{-1,0},{0,0},{1,0},{-1,1}},
  {{-1,-1},{0,-1},{0,0},{0,1}}
 },
 { -- o
  {{0,-1},{1,-1},{0,0},{1,0}},
  {{0,-1},{1,-1},{0,0},{1,0}},
  {{0,-1},{1,-1},{0,0},{1,0}},
  {{0,-1},{1,-1},{0,0},{1,0}}
 },
 { -- s
  {{0,-1},{1,-1},{-1,0},{0,0}},
  {{0,-1},{0,0},{1,0},{1,1}},
  {{0,0},{1,0},{-1,1},{0,1}},
  {{-1,-1},{-1,0},{0,0},{0,1}}
 },
 { -- t
  {{0,-1},{-1,0},{0,0},{1,0}},
  {{0,-1},{0,0},{1,0},{0,1}},
  {{-1,0},{0,0},{1,0},{0,1}},
  {{0,-1},{-1,0},{0,0},{0,1}}
 },
 { -- z
  {{-1,-1},{0,-1},{0,0},{1,0}},
  {{1,-1},{0,0},{1,0},{0,1}},
  {{-1,0},{0,0},{0,1},{1,1}},
  {{0,-1},{-1,0},{0,0},{-1,1}}
 }
}

function init_grid()
	for x=1,grid_w do
  grid[x] = {}
  for y=1,grid_h do
   grid[x][y] = 0
  end
 end
end

function init_pieces()
 ordered_pieces={}
 for j=1,7 do
  for i = 1,7 do
   add(ordered_pieces, i)
  end
 end
 add(ordered_pieces, 1) -- add an extra i piece to make it an even 50
 
 -- randomize order of pieces
 while #ordered_pieces > 0 do
  local p = deli(ordered_pieces, flr(rnd(#ordered_pieces+1)))
  add(pieces, p)
 end
 piece = deli(pieces)
end

function _init()
 -- set the initial delay before repeating. 255 means never repeat.
poke(0x5f5c, 8)
 -- set the repeating delay.
 poke(0x5f5d, 1)
 init_grid()
 init_pieces()
end

function move(x, y, r)
 -- check bounds
 for c in all(shapes[piece][r+1]) do
  if x+c[1] < 1 then
   return
  end
  if x+c[1] > grid_w then
   return
  end
  if y+c[2] < 1 then
   return
  end
  if y+c[2] > grid_h then
   return
  end
 end
 
 posx = x
 posy = y
 rot = r
end

function _update()
	if btnp(⬇️) then
		move(posx, posy+1, rot)
	end
	if btnp(⬆️) then
	 move(posx, posy-1, rot)
	end
	if btnp(⬅️) then
		move(posx-1, posy, rot)
	end
	if btnp(➡️) then
	 move(posx+1, posy, rot)
	end
	if btnp(❎) then
		move(posx, posy, (rot + 1) % 4)
	end
	if btnp(🅾️) then
		drop()
	end
end

function _draw()
 cls()
  
 -- board
 for x=1,grid_w do
  for y=1,grid_h do
   local tile = grid[x][y]
   if tile ~= 0 then
    spr(tile, x*grid_size, y*grid_size)
   else
    rect(x*grid_size, y*grid_size, (x+1)*grid_size-1, (y+1)*grid_size-1, 5)
   end
  end
 end
  
 -- active piece
 for c in all(shapes[piece][rot+1]) do
 	spr(piece, (posx+c[1])*grid_size, (posy+c[2])*grid_size)
 end
end

function drop()
 -- check if it fits
 for c in all(shapes[piece][rot+1]) do
  if grid[posx+c[1]][posy+c[2]] != 0 then
   -- todo juice
   return
  end
 end

 -- do the drop
 for c in all(shapes[piece][rot+1]) do
  grid[posx+c[1]][posy+c[2]] = piece
 end
 
 -- choose the next piece
 piece = deli(pieces)
 rot = 0
 posx = 5
 posy = 10
end
__gfx__
000000005cccc50051111500599995005aaaa5005bbbb50052222500588885000000000000000000000000000000000000000000000000000000000000000000
00000000ccc7cc001117110099979900aaa7aa00bbb7bb0022272200888788000000000000000000000000000000000000000000000000000000000000000000
00700700ccc7cc001117110099979900aaa7aa00bbb7bb0022272200888788000000000000000000000000000000000000000000000000000000000000000000
00077000cccccc001111110099999900aaaaaa00bbbbbb0022222200888888000000000000000000000000000000000000000000000000000000000000000000
00077000cccccc001111110099999900aaaaaa00bbbbbb0022222200888888000000000000000000000000000000000000000000000000000000000000000000
007007005cccc50051111500599995005aaaa5005bbbb50052222500588885000000000000000000000000000000000000000000000000000000000000000000
