pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

-- for collision detection,
-- there are some choices.
--
-- what shape are our hitboxes?
--
-- do we do vector-based to
-- avoid things passing through
-- each other at high speed?
--
-- do we do space partitioning
-- to make it more efficient to
-- check lots of collisions?

function _init()
 actors = {}
 for i=1,10 do
  add(actors,make_actor())
 end
end

function make_actor()
 return {
		x=rnd(112)+8,
		y=rnd(112)+8,
	 xv=rnd(4)-2,
	 yv=rnd(4)-2
	}
end

function update_actor(actor)
 actor.x += actor.xv
 actor.y += actor.yv
 if actor.x >= 120 then
 	sfx(0)
 	actor.xv = -abs(actor.xv)
 end
 if actor.x <= 1 then
 	sfx(0)
  actor.xv = abs(actor.xv)
 end
 if actor.y >= 120 then
 	sfx(0)
 	actor.yv = -abs(actor.yv)
 end
 if actor.y <= 1 then
 	sfx(0)
 	actor.yv = abs(actor.yv)
 end
 if actor.xv > 4 then
 	actor.xv = 4
 end
 if actor.yv > 4 then
  actor.yv = 4
 end
 actor.xv /= 1.01
 actor.yv /= 1.01
end

function calc_distance(a,b)
 local dx=actors[b].x - actors[a].x
 local dy=actors[b].y - actors[a].y
 local distance=sqrt(dx*dx + dy*dy)
 return dx,dy,distance
end

function update_until_clear(a,b)
 -- assumes is already colliding
 -- todo ideally would update until almost clear
 -- so the next real update clears them
 local distance=0
 while distance < 8 do
 	update_actor(actors[a])
 	update_actor(actors[b])
 	_,_,distance=calc_distance(a,b)
 end
end

function collide(a,b)
 -- calc normal vector
 local dx,dy,distance=calc_distance(a,b)
 if distance < 8 then
  sfx(0)
  -- normalize it
  dx/=distance
  dy/=distance
  -- decompose into normal and tangential components
  local v1n =  actors[a].xv * dx + actors[a].yv * dy
  local v1t = -actors[a].xv * dy + actors[a].yv * dx
  local v2n =  actors[b].xv * dx + actors[b].yv * dy
  local v2t = -actors[b].xv * dy + actors[b].yv * dx
  -- swap normal components since elastic
  actors[a].xv = v2n * dx - v1t * dy
  actors[a].yv = v2n * dy + v1t * dx
  actors[b].xv = v1n * dx - v2t * dy
  actors[b].yv = v1n * dy + v2t * dx
  update_until_clear(a,b)
 end
end

function normalize(x,y)
 dist=sqrt(x*x + y*y)
 if x != 0 then
  x/=dist
 end
 if y != 0 then
	 y/=dist
	end
 return x,y
end

function _draw()
 cls(5)
 for x=1,#actors do
  for y=1,x do
   if x != y then
	   collide(x, y)
	  end
  end
 end
 for a in all(actors) do
  update_actor(a)
 end
 for a=1,#actors do
  if a == 1 then
 		spr(1,actors[a].x,actors[a].y)
 	else
  	spr(2, actors[a].x, actors[a].y)
  end
 end
 local dxv=0
 local dyv=0
 if btn(⬅️) and actors[1].x>1 then
 	dxv = -1
 end
 if btn(➡️) and actors[1].x<120 then
 	dxv = 1
 end
 if btn(⬆️) and actors[1].y>1 then
 	dyv = -1
 end
 if btn(⬇️) and actors[1].y<120 then
 	dyv = 1
 end
	dxv,dyv = normalize(dxv,dyv)
 actors[1].xv += dxv*.1
 actors[1].yv += dyv*.1
end
__gfx__
00000000001111000011110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000016666100122221000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007001636636112dd222100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770001666666112ddd22100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700013666631122dd22100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700163333611222222100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000016666100122221000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001111000011110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100003707037050370403703037030370303702037020370203702037020370203702037020370203701037010370103701036000360003600036000360003500035000350003500035000350003600036000
