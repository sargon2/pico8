pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _update()
end

minb=10
maxb=118

dots={}
vectors={}
function _init()
 for i=1,100 do
  dots[i]={rnd(maxb-minb)+minb,rnd(maxb-minb)+minb}
  vectors[i]={0,0}
 end
end

function _draw()
 cls()
 for i=1,#dots do
  pset(dots[i][1],dots[i][2],7)
  dots[i][1] += vectors[i][1]
  dots[i][2] += vectors[i][2]
  vectors[i][1] += (rnd(2)-1)*.1
  vectors[i][2] += (rnd(2)-1)*.1
  if dots[i][1] < minb then
   vectors[i][1] += 0.1
  end
  if dots[i][1] > maxb then
  	vectors[i][1] -= 0.1
  end
  if dots[i][2] < minb then
   vectors[i][2] += 0.1
  end
  if dots[i][2] > maxb then
  	vectors[i][2] -= 0.1
  end
  // max speed
  l=sqrt(vectors[i][1]^2+vectors[i][2]^2)
  if l > 2 then
   vectors[i][1] *= 0.8
   vectors[i][2] *= 0.8
  end
  // min speed
  if l < 0.1 then
   vectors[i][1] *= 1.2
   vectors[i][2] *= 1.2
  end
 end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
