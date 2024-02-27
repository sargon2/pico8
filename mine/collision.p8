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

actor1 = {
 x=rnd(112)+8,
 y=rnd(112)+8,
 xv=rnd(4)-2,
 yv=rnd(4)-2
}

actor2 = {
 x=rnd(112)+8,
 y=rnd(112)+8,
 xv=rnd(4)-2,
 yv=rnd(4)-2
}

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

is_colliding = false
function collide()
 -- calc normal vector
 local dx=actor2.x - actor1.x
 local dy=actor2.y - actor1.y
 local distance=sqrt(dx*dx + dy*dy)
 if distance < 8 then
  if is_colliding then
   -- we already calculated this collision
   return
  end
  sfx(0)
  is_colliding = true
  -- normalize it
  local nx=dx/distance
  local ny=dy/distance
  -- decompose into normal and tangential components
  local v1n =  actor1.xv * nx + actor1.yv * ny
  local v1t = -actor1.xv * ny + actor1.yv * nx
  local v2n =  actor2.xv * nx + actor2.yv * ny
  local v2t = -actor2.xv * ny + actor2.yv * nx
  -- swap normal components since elastic
  actor1.xv = v2n * nx - v1t * ny
  actor1.yv = v2n * ny + v1t * nx
  actor2.xv = v1n * nx - v2t * ny
  actor2.yv = v1n * ny + v2t * nx
 else
 	is_colliding = false
 end
end

function _draw()
 cls(5)
 update_actor(actor1)
 update_actor(actor2)
 collide()
 spr(1,actor1.x,actor1.y)
 spr(2,actor2.x,actor2.y)
 if btn(⬅️) then
 	actor1.xv -= 0.1
 end
 if btn(➡️) then
 	actor1.xv += 0.1
 end
 if btn(⬆️) then
 	actor1.yv -= 0.1
 end
 if btn(⬇️) then
 	actor1.yv += 0.1
 end
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
0001000019660156201161019600106001d6000f600136001360000600006000060000600006000060000600006000060000600006000060000600006001c6000060000600006000060000600006000060000600
